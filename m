Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8B368D5A
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 16:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403045; cv=none; b=cTBHgkW4UXjKIIgji7YxLcOhOHZnY1C5AV4fYy7QtpXBjDv/d3dSHlVaDmQ+20nonvUQTeNnmg5sYCFNCZtmne2hCBiwAYcjSSOb6OrBR+KOxoZNHZ1uk9FwfnOQDmgRsaY5QmgD2qGcDCwUtT9+myWNbw37YRb038J8MSI5UYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403045; c=relaxed/simple;
	bh=+462xxdyeMC1GN/R2WQFu0vf/hv5y4sjHsNqOzNci58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdIuRPBLsKlUPk0Iya5p6vlEkaMzpfNkAKNx4Hs3Cx8r4RMr/XLJsFmqTGMg4XYVa9poNBW1AjRctG9QuvqtT+z+RxToeTY5Xp2x6xb59JUPyalRv99pxiZlQoraOSL24ghl1JswfaFkZ4N/zHyD8Cm1hlob9dU3h6/CEcHfsjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V7T3YCKz; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V7T3YCKz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+462xxdyeMC1GN/R2WQFu0vf/hv5y4sjHsNqOzNci58=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789403041; v=1; x=1790007841;
 b=V7T3YCKz5vFV14QVyuD4y42Y18oMJy7rhUaOharFDbbZ1WnXwpiEFcxNeyFso/C156OrPfKR
 hpozSI81ic8QMH/EuiwVcFjjM8zP5RQKSX0J7pQ/HvM43bfmo+LqQGHbsPyz56EMZ4tWEFFtsXJ
 l+swkPb9Q9FsWWtF4A4ON/ps=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bc63234f3f952a90;
	Mon, 14 Sep 2026 16:24:01 +0000
X-Mizu-Trace-ID: bc63234f3f952a90
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so9846e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 09:23:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwhr366E12R6EPEo+FyLaZE6Cb5DWJsn/FEZK3r2hUTnC5/EavSGj9mjnF4sqyjdMWWa1KO3wU=@lists.linux.dev
X-Gm-Message-State: AFuF++mS7GdpqJW15I3wncXlyaHqsOT5ime9BKIhEdmRN1qggjafPJfV
	x0jzo6v5ivVwS1wWc+hdugidUR1oMf2uaep2lpPY0+hauze0YRYdv465FPCFQydzsu4TLAcz61g
	WNywBBd/h/WQPQMaJvdRQQy4wyZNjQPfrhCAbfKNK
X-Received: by 2002:ac2:5681:0:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b8ae4c4829mr98689e87.6.1789403036316; Mon, 14 Sep 2026
 09:23:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260830-host-direct-messages-v7-0-45f6e6db72c2@google.com> <20260830-host-direct-messages-v7-1-45f6e6db72c2@google.com>
In-Reply-To: <20260830-host-direct-messages-v7-1-45f6e6db72c2@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 17:23:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx54xunFQxmAo_Ub+C4ZhhPvhixdkenfWV4rkF0jPCNsA@mail.gmail.com>
X-Gm-Features: AcwNN1X2uetrRmFIoGYENcfcuU7e1BdSXNmH8r5ZduL9wOubCa5NrjEj-eVtpTM
Message-ID: <CA+EHjTx54xunFQxmAo_Ub+C4ZhhPvhixdkenfWV4rkF0jPCNsA@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] KVM: arm64: Block host-initiated FF-A direct responses
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Sebastien Ene <sebastianene@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Per,

On Mon, 31 Aug 2026 at 00:08, Per Larsen via B4 Relay
<devnull+perlarsen.google.com@kernel.org> wrote:
...
> @@ -686,8 +686,10 @@ static bool ffa_call_supported(u64 func_id)
>   case FFA_MSG_SEND:
>   case FFA_MSG_POLL:
>   case FFA_MSG_WAIT:
> - /* 32-bit variants of 64-bit calls */
> + /* The host is never the target of a direct request */
>   case FFA_MSG_SEND_DIRECT_RESP:
> + case FFA_FN64_MSG_SEND_DIRECT_RESP:
> + /* 32-bit variants of 64-bit calls */
>   case FFA_RXTX_MAP:
>   case FFA_MEM_DONATE:
>   case FFA_MEM_RETRIEVE_REQ:

Sashiko asked whether the interfaces it listed should be added to the
blocklist too. For FFA_FN64_NOTIFICATION_INFO_GET the answer looks
like yes: FFA_FN_NATIVE() is FFA_FN64_##name on arm64, and
ffa_notification_info_get() is the only in-tree caller, so the 32-bit
entry a few lines below never matches what the host sends. Could you
add it here?

The other three aren't the same case. FFA_RX_RELEASE has to keep going
through, since the host's release is what frees the hypervisor's RX
buffer after do_ffa_part_get().

Cheers,
/fuad
