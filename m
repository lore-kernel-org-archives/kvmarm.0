Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0378837B030
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 16:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782404151; cv=none; b=ScH+oiULnYrQUYuvEczz6u71I2JecBH+8e+frcqh11aO6fzKSlGpiP9k5btN5G3ieWCR+wwVhFKWeAE1cZLpGjzjYPhO9deXlS+s6/c/8CkMtK5H/cPyLdhTuJtQ3qTrM8MUNVL4gCKHaC/qwsnUlZP2JtTfjO7MAM0SAmhSUwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782404151; c=relaxed/simple;
	bh=g1B1cvHyOF8jXKsO42iY7id1Lb56+h85qCBGS2Z5zyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N9IGsgwCYrTyA6ONlcElYEcUY23syrl+HNddtXpABlNgksrAhJsfaxd9ib2aUWqX5JypCmLdB3hxkhjnwWsjlatAYgx3+C+bjNbzrZ5fCmSN50mIa9XRds3+u8VziXEr9OkpGdhDV4nPaC/j4P4QfMXua341r/ZB2d4ER/pGqeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WsY979Ck; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WsY979Ck"
X-Gm-Message-State: AOJu0YxsEmL/yIUJZzhMR9M5Iastv1ZQSfBAQ3L9lk/DmScP5BAH7kI9
	f3S7MbPO/1tiGaYX91cqEWyZEMCUVwa3xTbTK4UueRbkEow/3fJ3GXeOwPq1OracO5oL3RRTvn8
	91++iTe4wcH1xlqF+Dmfe9KR8sOf0EVXHvZWUQC5M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782404146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nzzok+ws8sgLCcoLt6BxzJuaEaiIk2UI7TgTr+Q9kQU=;
	b=WsY979CkTXaBgSGOkN0YGqZB2Z1K/KX8encTRtm1/x+GhZaZR3gYRiW49J0xgzfz05Wlqu
	6B6ix7sjBLqlBfyOv9EjzsHzDbzrf2qay/Y5NptR87/o6fKBY5sbk+aV5vMGflwOaYi1kY
	Zcsbw+WCrkvn0PYm8KEgxIcSq4m4vTY=
X-Received: by 2002:a05:622a:2610:b0:517:5ec3:b59c with SMTP id
 d75a77b69052e-51a6e99fc93mr11713871cf.2.1782404139969; Thu, 25 Jun 2026
 09:15:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625144807.2603272-1-fuad.tabba@linux.dev>
 <20260625144807.2603272-3-fuad.tabba@linux.dev> <20260625145703.460B41F000E9@smtp.kernel.org>
In-Reply-To: <20260625145703.460B41F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 25 Jun 2026 17:14:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzaPwrS363oGXUCqNz+O1Hho4Z7zAsbBik8mO-eQSKD=g@mail.gmail.com>
X-Gm-Features: AVVi8CdDBKermqUbxAG9chDiZX1S1v9hJkMy-Mo7dX4CKTB7W6jSYzxLH6sOxn0
Message-ID: <CA+EHjTzaPwrS363oGXUCqNz+O1Hho4Z7zAsbBik8mO-eQSKD=g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: selftests: Add MMIO sign-extending
 load test
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Thu, 25 Jun 2026 at 15:57, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] Guest EL1 will crash with an Instruction Abort because the `el=
0_be_loads` assembly block shares a page with EL1 test code and is marked a=
s EL0-accessible.
> --
>
> commit 60c24b3648e8f92661ec2d484d27ac4580cad60a
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: selftests: Add MMIO sign-extending load test
>
> Adds a test for sign-extending MMIO loads (LDRSB, LDRSH, LDRSW) into Xt
> and Wt destinations, with and without the sign bit set. The host supplies
> the MMIO data and checks the guest register holds the sign-extended value=
.
>
> > diff --git a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c b/tools/=
testing/selftests/kvm/arm64/mmio_sign_ext.c
> > new file mode 100644
> > index 0000000000000..06708ab6db8c0
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
>
> [ ... ]
>
> > +extern char el0_be_loads[], el0_be_loads_end[];
> > +asm(
> > +"    .pushsection .text, \"ax\"\n"
> > +"    .global el0_be_loads\n"
> > +"el0_be_loads:\n"
>
> [Severity: Medium]
> Will this crash guest EL1 with an Instruction Abort?
>
> The el0_be_loads assembly block lacks page alignment directives, placing =
it
> adjacent to EL1 executable code in the same page of the .text section.
>
> When make_el0_accessible() is called in main():
>
>     make_el0_accessible(vm, (uint64_t)el0_be_loads,
>                         el0_be_loads_end - el0_be_loads);
>
> It makes the shared page EL0-accessible by setting PTE_USER. This
> inadvertently makes the EL1 guest_code on the same page EL0-accessible. I=
n
> the ARMv8 EL1&0 translation regime, an instruction fetch by EL1 from an
> EL0-accessible memory page unconditionally generates a Permission Fault.

Nice catch! You're right: AP[2:1]=3D01 grants UnprivWrite, and the
architecture removes PrivExecute whenever UnprivWrite is present,
regardless of PXN (ARM ARM D8.4.1.2). The call is also unnecessary:
EL0 instruction fetch is controlled by UXN (already 0), not AP bits.
The EL0 stub only needs data access to the MMIO page, not to its own
code.

The fix is to drop the second make_el0_accessible call and the
now-unused el0_be_loads_end label. Re-tested with and without the
previous patch (patch 1/2), all tests pass with the fix and the first
sign-bit case fails without it.

Marc, can you fold this in or would you like me to respin?

--- a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
+++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
@@ -77,7 +77,7 @@ static void guest_loads_le(void)
  * fault on the little-endian tables. x0 holds MMIO_ADDR; results return i=
n
  * x19..x28 (tests[] order) via a single SVC.
  */
-extern char el0_be_loads[], el0_be_loads_end[];
+extern char el0_be_loads[];
 asm(
 "    .pushsection .text, \"ax\"\n"
 "    .global el0_be_loads\n"
@@ -93,8 +93,6 @@ asm(
 "    ldrsw    x27, [x0]\n"
 "    ldrsw    x28, [x0]\n"
 "    svc    #0\n"
-"    .global el0_be_loads_end\n"
-"el0_be_loads_end:\n"
 "    .popsection\n"
 );

@@ -213,11 +211,8 @@ int main(void)
                 el0_svc_handler);

     be =3D vcpu_mixed_endian_el0(vcpu);
-    if (be) {
+    if (be)
         make_el0_accessible(vm, MMIO_ADDR, vm->page_size);
-        make_el0_accessible(vm, (uint64_t)el0_be_loads,
- el0_be_loads_end - el0_be_loads);
-    }

     ksft_print_header();
     ksft_set_plan(ARRAY_SIZE(tests) * (be ? 2 : 1));


Cheers,
/fuad





>
> > +"    ldrsb   x19, [x0]\n"
> > +"    ldrsb   x20, [x0]\n"
> > +"    ldrsb   w21, [x0]\n"
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625144807.26=
03272-1-fuad.tabba@linux.dev?part=3D2
>
