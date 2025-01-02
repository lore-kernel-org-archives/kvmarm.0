Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B732C43ABD
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 14:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735829039; cv=none; b=U3ChowDQCIWeWKnCRQ+sIhNMhh+kiuuR8LFCzRHM0n+Yj+GqHXxIQ6ETHoAbS35ySN6iBeKtVHq9vpZwUNjQHyvPC/uK2Rb/7WKnoFJEAkutWBwWefDUCAB6yftn0PTUOtZxs/nYZrqz6FVkJGwwoygOFLAodMxjCUEEJeMKtNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735829039; c=relaxed/simple;
	bh=st138F9EP3NQbCaMSzNpFx9ulqK02cYIA5l3kYhxyIE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AHu3ZTupsigNzaxw2x9H7j2nSj7G+PXXfq8p7arzWjpnanNm4XsLUNjRGQloq7hx/HlOU3Zh5K3fNmTupcNdsGB3gpldZQKSBuoQLFYyO6txjtxx8RjbydgchIwXTxpc4GkVE/EyDih65WNk4rg+zxT0srOudxaxpcV+ZSqXNqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+/4sp0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+/4sp0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FB9C4CED0;
	Thu,  2 Jan 2025 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735829039;
	bh=st138F9EP3NQbCaMSzNpFx9ulqK02cYIA5l3kYhxyIE=;
	h=From:To:Cc:Subject:Date:From;
	b=H+/4sp0pLcp0+Ay5MnARRNyPYX9oCYVCli4zWxN2/Y0Kjxe7QifZPDjhkwb/jpmxN
	 nn+zj/Ebr5a/ybMKGetCuLR+2CZl7mdI/ZqVbg1n4J/pUzGiZuAwI2IDQuplHnHur6
	 2WVBxBZwK87zEILMSJL/ypFi95zbv3STLzvKG+rlQEQc3KqVmPyUUdDlHdyuDS0hvR
	 /ClS9FeeV1fE8DfTRW8V64pe/IDtHyzCkxTGVH3yx0CNrLA7l/DmL43FFl9xQ70T4Q
	 1dJfUrHjnmgAIkpmVCbFWRSsgdFL1MF8H9HK9J1BzrUjk/OgyIYfYdjAE2/3vv+k3o
	 sGzUK6g+KVVQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tTMQW-008RCM-Mz;
	Thu, 02 Jan 2025 14:43:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2] arm64: Add basic JSON register parser
Date: Thu,  2 Jan 2025 14:43:39 +0000
Message-Id: <20250102144339.1564778-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, mark.rutland@arm.com, catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently populate the sysreg file by hand from the ARM ARM,
resulting in a bunch of errors being introduced on a regular basis.
While there is an XML dump of the architecture produced on a quarterly
basis, the license that comes attached to it excludes any sort of
open-source usage.

However, ARM has recently made available a JSON dump[1] that contains
a reduced set of information under a BSD license. This has enough
data to extract what is relevant to the sysreg file.

This is achieved using a JQ script that I cobbled together over
the holiday, and while it has a number of limitations, it already
works well enough to extract useful data.

As an example, here's what the script returns for TCR_EL1:

$ jq -r --arg REG TCR_EL1 -f arch/arm64/tools/dumpreg.jq ~/Work/XML/2024-12/AARCHMRS_BSD_A_profile/Registers.json
TCR_EL1	[3,0,2,0,2]	MRS
TCR_EL1	[3,0,2,0,2]	MSRregister
TCR_EL12	[3,5,2,0,2]	MRS
TCR_EL12	[3,5,2,0,2]	MSRregister
TCRALIAS_EL1	[3,0,2,7,6]	MRS
TCRALIAS_EL1	[3,0,2,7,6]	MSRregister
Res0	63:62
Field	61	MTX1	# Field cond: (IsFeatureImplemented(FEAT_MTE_NO_ADDRESS_TAGS) || IsFeatureImplemented(FEAT_MTE_CANONICAL_TAGS))
Field	60	MTX0	# Field cond: (IsFeatureImplemented(FEAT_MTE_NO_ADDRESS_TAGS) || IsFeatureImplemented(FEAT_MTE_CANONICAL_TAGS))
Field	59	DS	# Field cond: (IsFeatureImplemented(FEAT_LPA2) && (!IsFeatureImplemented(FEAT_D128) || (AArch64 TCR2_EL1.D128 == '0')))
Field	59	DS	# Field cond: true
Field	58	TCMA1	# Field cond: IsFeatureImplemented(FEAT_MTE2)
Field	57	TCMA0	# Field cond: IsFeatureImplemented(FEAT_MTE2)
Field	56	E0PD1	# Field cond: IsFeatureImplemented(FEAT_E0PD)
Field	55	E0PD0	# Field cond: IsFeatureImplemented(FEAT_E0PD)
Field	54	NFD1	# Field cond: (IsFeatureImplemented(FEAT_SVE) || IsFeatureImplemented(FEAT_TME))
Field	53	NFD0	# Field cond: (IsFeatureImplemented(FEAT_SVE) || IsFeatureImplemented(FEAT_TME))
Field	52	TBID1	# Field cond: IsFeatureImplemented(FEAT_PAuth)
Field	51	TBID0	# Field cond: IsFeatureImplemented(FEAT_PAuth)
Field	50	HWU162	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	49	HWU161	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	48	HWU160	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	47	HWU159	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	46	HWU062	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	45	HWU061	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	44	HWU060	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	43	HWU059	# Field cond: IsFeatureImplemented(FEAT_HPDS2)
Field	42	HPD1	# Field cond: IsFeatureImplemented(FEAT_HPDS)
Field	41	HPD0	# Field cond: IsFeatureImplemented(FEAT_HPDS)
Field	40	HD	# Field cond: IsFeatureImplemented(FEAT_HAFDBS)
Field	39	HA	# Field cond: IsFeatureImplemented(FEAT_HAFDBS)
Field	38	TBI1
Field	37	TBI0
Field	36	AS
Res0	35
Field	34:32	IPS
Field	31:30	TG1
Field	29:28	SH1
Field	27:26	ORGN1
Field	25:24	IRGN1
Field	23	EPD1
Field	22	A1
Field	21:16	T1SZ
Field	15:14	TG0
Field	13:12	SH0
Field	11:10	ORGN0
Field	9:8	IRGN0
Field	7	EPD0
Res0	6
Field	5:0	T0SZ

I completely expect this to quickly rewritten by people who know
what they are doing (I don't) and improved as we understand more
of the data model.

[1] https://developer.arm.com/-/cdn-downloads/permalink/Exploration-Tools-OS-Machine-Readable-Data/AARCHMRS_BSD/AARCHMRS_BSD_A_profile-2024-12.tar.gz

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
---

Notes:
    - From v1:
    
      - Fix the accessor encoding order
      - Handing of nesting fields, arrays, vectors
      - Plenty of additional JSON handling

 arch/arm64/tools/dumpreg.jq | 258 ++++++++++++++++++++++++++++++++++++
 1 file changed, 258 insertions(+)
 create mode 100644 arch/arm64/tools/dumpreg.jq

diff --git a/arch/arm64/tools/dumpreg.jq b/arch/arm64/tools/dumpreg.jq
new file mode 100644
index 0000000000000..efb198066820f
--- /dev/null
+++ b/arch/arm64/tools/dumpreg.jq
@@ -0,0 +1,258 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# dumpreg.jq: JSON arm64 system register data extractor
+#
+# Author: Marc Zyngier <maz@kernel.org>
+#
+# Usage: jq -r --arg REG "XZY_ELx" -f ./dumpreg.jq Registers.json
+
+# Dump a set of semi-pertinent informations (encodings, fields,
+# conditions, field position and width) about register XZY_ELx as
+# contained in ARM's AARCHMRS_BSD_A_profile JSON tarball.
+
+# Not setting REG will dump the whole register file in one go. While
+# this is entertaining, it isn't very useful.
+
+# This can/should be used to populate the arch/arm64/tools/sysreg
+# file, instead of copying things by hand.
+
+# The tool currently has a bunch of limitations that users need to be
+# aware of, but none that should have a major impact on the usability:
+
+# - All accessors are shown, irrespective of the conditions in which
+#   the accessors are actually available
+
+# - All Fields.ConstantField are displayed as UnsignedEnum,
+#   irrespective of the signess of the field (as the JSON doesn't
+#   carry this information).
+
+# - Value ranges are displayed using '[...]'.
+
+# - Fields are processed and displayed in the order of the JSON
+#   source, which may not be the order in the register.
+
+# - Conditional fields may appear multiple times.
+
+# - ... and probably more...
+
+def walknode:
+	def walkjoin(s):
+		map(walknode) | join(s);
+
+        if   (._type == "AST.Identifier" or ._type == "AST.Integer" or
+	      ._type == "Values.Value" or ._type == "AST.Bool" or
+	      ._type == "Types.String") then
+	     	.value
+	elif (._type == "Types.Field") then
+		"\(.value.name).\(.value.field)"
+	elif (._type == "AST.UnaryOp") then
+		"\(.op)(\(.expr | walknode))"
+	elif (._type == "AST.Function") then
+		"\(.name)(\(.arguments | walkjoin(", ")))"
+	elif (._type == "AST.DotAtom") then
+		.values | walkjoin(".")
+	elif (._type == "AST.BinaryOp") then
+		"(\(.left | walknode) \(.op) \(.right | walknode))"
+	elif (._type == "Types.RegisterType") then
+		.name
+	elif (._type == "AST.Type") then
+		"\(.name | walknode)"
+	elif (._type == "AST.Slice") then
+		"\(.left.value):\(.right.value)"
+	elif (._type == "AST.Set") then
+		.values | map(walknode)
+	elif (._type == "AST.Assignment")  then
+		"\(.var | walknode) = \(.val | walknode)"
+	elif (._type == "AST.TypeAnnotation")  then
+		"\(.var | walknode):\(.type | walknode)"
+	elif (._type == "AST.SquareOp") then
+		"\(.var | walknode)[\(.arguments | walkjoin(", "))]"
+	elif (._type == "AST.Return") then
+		"return"
+	elif (._type == "AST.Concat") then
+		"[\(.values | walkjoin(", "))]"
+	elif (._type == "AST.Tuple") then
+		"(\(.values | walkjoin(", ")))"
+	else	# debug catch-all
+		.
+	end;
+
+def range:
+	. as { _type: $type, start: $start, width: $width } |
+	if ($width == 1) then
+		"\($start)"
+	else
+		"\($start + $width - 1):\($start)"
+	end;
+
+def fld:
+	(if (.condstr.text) then "\t\(.condstr.text)"
+	 else "" end) as $cond |
+	"\(.type)\t\(.range | range)\t\(.name)\($cond)";
+
+def condition(source):
+	"# \(source) cond: \(.condition | walknode)";
+
+def unquote:
+	"'" as $q | (ltrimstr($q) | rtrimstr($q));
+
+def binvalue:
+	.value | unquote as $v | "\t0b\($v)\tVAL_\($v)";
+
+def dumpconstants:
+	if   (._type == "Values.Value") then
+		binvalue
+	elif (._type == "Values.ValueRange") then
+		(.start | binvalue), "\t[...]", (.end | binvalue)
+	elif (._type == "Values.ConditionalValue") then
+		"\(.values.values[] | dumpconstants)\t\(condition("Value"))"
+ 	else	# Debug catch all
+		.
+	end;
+
+def dumpenum:
+	# Things like SMIDR_EL1.Affinity do not describe
+	# the value range, hence the []? hack below.
+	(.value.constraints.values[]? | dumpconstants);
+
+def genarrayelt(n; bpf):
+	"<\(.index_variable)>" as $v |
+	(.rangeset | reverse) as $rs |
+	($rs | length) as $nrs |
+	{
+		_type: (if (bpf > 1) then "Fields.ConstantField"
+			else "Fields.Field" end),
+		name: (.name | sub($v; "\(n)")),
+		rangeset: [
+			{
+				_type: "Range",
+				start: (if ($nrs > 1) then $rs[n].start
+				        else $rs[0].start + n * bpf end),
+				width: bpf
+			}
+		],
+		value: { constraints: .values },
+		condstr: (if (.condstr) then
+			    { text: (.condstr.text | sub($v; "\(n)")) }
+			  else
+			    null
+			  end)
+	};
+
+def genarray:
+	# Oh the fun we're having: convert each element of the array
+	# into its own architectural field, warts and all. Additional
+	# fun is provided to compute the number of bits per fields,
+	# as the elements can be spread over multiple rangesets.
+	. as $field |
+	.indexes[0].width as $nr |
+	((reduce .rangeset[].width as $sz (0; . + $sz)) / $nr) as $bpf |
+	[ range(0; $nr) ] | reverse | map(. as $n | $field | genarrayelt($n; $bpf));
+
+# For each range of a field, unpack it as start and width, and
+# apply it to each range of the parent field (used as a base).
+# Although this can result in a combinatorial explosion, the
+# likely case is that one of the two sets is of size one.
+def mergerangesets(base):
+	.[] |
+	.start as $s |
+	.width as $w |
+	base | map({
+			_type: "Range",
+			start: (.start + $s),
+			width: ([ $w, .width ] | min)
+		   });
+
+def depthstr(depth):
+	[ range(0, depth) ] | map(32, 32) | implode;
+
+def walkfields(depth):
+	depthstr(depth) as $dep |
+	if   (._type == "Fields.Reserved" and .value == "RES0") then
+		{ type: "Res0", name: "", range: .rangeset[] } |
+		"\($dep)\(fld)"
+	elif (._type == "Fields.Reserved" and .value == "RES1") then
+		{ type: "Res1", name: "", range: .rangeset[] } |
+		"\($dep)\(fld)"
+	elif (._type == "Fields.ConditionalField") then
+		# Propagate the condition text over all conditional
+		# fields by injecting a new ".condstr.text" field.
+		# Also, the ranges must be combined as they nest.
+		.rangeset as $r |
+		.fields | map(condition("Field") as $c |
+			      .field.condstr |= { text: $c }) |
+			  map(.field.rangeset |= mergerangesets($r)) |
+		.[] | .field | walkfields(depth)
+	elif (._type == "Fields.Dynamic") then
+		({ type: "Field", name: .name, range: .rangeset[], condstr: .condstr } | fld),
+	     	(.rangeset as $r | .instances[] |
+		 ((.display // .name // "Instance") as $src |
+		  "\(depthstr(depth + 1))\(condition($src))",
+		  # Remap the rangesets to display the absolute range
+		  (.values | map(.rangeset |= mergerangesets($r)) |
+		   .[] | walkfields(depth + 1))))
+	elif (._type == "Fields.ConstantField") then
+		({ type: "UnsignedEnum", name: .name, range: .rangeset[], condstr: .condstr } |
+		 "\($dep)\(fld)"),
+		dumpenum,
+		"EndEnum"
+	elif (._type == "Fields.Field") then
+		{ type: "Field", name: .name, range: .rangeset[], condstr: .condstr } |
+		"\($dep)\(fld)"
+	elif (._type == "Fields.Reserved") then
+		{ type: "Field", name: .value, range: .rangeset[], condstr: .condstr } |
+		"\($dep)\(fld)"
+	elif (._type == "Fields.ImplementationDefined") then
+		{ type: "Field", name: (.name // "IMPDEF"), range: .rangeset[], condstr: .condstr } |
+		"\($dep)\(fld)"
+	elif (._type == "Fields.Array" or ._type == "Fields.Vector") then
+	     	genarray | .[] | walkfields(depth)
+ 	else	# Debug catch all
+		.
+	end;
+
+def tautology:
+	(.condition.value == true);
+
+def walkreg:
+	(.fieldsets | length) as $l |
+	.fieldsets[] |
+	  (if ($l > 1 or (tautology | not)) then condition("Fieldset") else empty end),
+	  (.values[] | walkfields(0));
+
+def bin_to_i:
+	def bintoi:
+		(length - 1) as $e |
+		((.[0] - 48) * ($e | exp2)) + (if ($e > 0) then .[1:] | bintoi
+				     	       else 0 end);
+	explode | bintoi;
+
+def computeencoding:
+	if (.) then
+		if   (._type == "Values.Value") then .value | unquote | bin_to_i
+		elif (._type == "Values.Group") then .value
+		elif (._type == "Values.EquationValue") then "\(.value)[\(.slice[] | range)]"
+		else . # Debug catch all
+		end
+	else
+		"#Imm"
+	end;
+
+def encodings:
+	.encodings | [ .op0, .op1, .CRn, .CRm, .op2 ] | map(computeencoding);
+
+def accessorencoding:
+	(.name | ltrimstr("A64.")) as $name |
+	.encoding[] | "\(.asmvalue)\t\(encodings)\t\($name)";
+
+def accessors:
+	.accessors[] |
+	accessorencoding;
+
+def regcondition:
+	if (tautology | not) then condition("Reg") else empty end;
+
+.[] | select (._type == "Register" or ._type == "RegisterArray") |
+      select (.state == "AArch64" and
+	      ($ARGS.named.REG == null or .name == $ARGS.named.REG)) |
+      "# \(.name)",accessors,regcondition,walkreg
-- 
2.39.2

