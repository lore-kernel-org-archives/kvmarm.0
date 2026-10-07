Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA54047F3D2
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 11:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372296; cv=pass; b=ix8cYXETmCSPDPBX8EyYvF8A53VO7KE7VRHsCUGPgx6zyZOUZx6dvVSupz7PFEQ6cMwLlycLrb0BsqkYKEVtQXSkaIDWRbGc5HYJM0wSMw7SUeEEfoMiXdsNWQzhsYN0D4xN39wzXD5nvnp8ekkrR8UWygo6/FatbJZaOcwENc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372296; c=relaxed/simple;
	bh=e6PnbIvoXOZFv6pPRVmqWiNMYIregQMXJAxqLvuHzdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jp7B35Jz1SrLAJ06/+LbOenVzYdDDv1eeLX9p6jc0zQmrZOlGnj0ImypJCKcS4LPttXUOlHP7y+8e16bwAeJ/UhSOiiuK7R3MvJCF7LH6Cxckw2RRgQ+OTt0BNIno0lrYjzlTZ1OwylT5B4fAvu+Fzwpc0YgImII3S2wnDVDP6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pkl6bObz; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pkl6bObz"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so5748e87.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 04:24:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791372276; cv=none;
        d=google.com; s=arc-20260327;
        b=WnS13a08qVn0pssBuvheeFnrOpRyA0ig4e74xVAtaN/u9ky6GPKY/KXaS6q/7Kd75i
         4ywXC3zOaijeFW94n9NjmpELJoua0uNpWnriiY9pRQJGr0T18+zxnh8vXCHGzJ+YEIDK
         Oq+D9lRN/W0MYhxT+wY+0m5UKeQVM7uTEM00QVUO6B5WHE6Er/tWxDhp5gDMKHEwSNjc
         H9YwDYMRYkDAJt8qAuqZByhqvg5k3UPKdNkkoQ5MDG+R9IxSsBbEmokI07+cLSuXdiee
         16fmgkNKNIYI1nmgKbc3p+s34HtXN97Tb4SiLBnRUuvlOVf3lySVBybyyCJCVhwLa4Nl
         kd8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e6PnbIvoXOZFv6pPRVmqWiNMYIregQMXJAxqLvuHzdE=;
        fh=Mh5k8U/FShtJHSPcVKQIHMklDgVVlz26aqT+XSypBgk=;
        b=FV5EZDyUKOJqK78LyZ/rtahcKw+Duk+lX6FmyNLYjw9Usvrdi5sjQdwG/876L/jhwY
         sRwuGg/lsiPD8Yrna1cwbbDglsm40vyM1eDfbqDfnh9qW7nBEZHQ5y5IeKribyU3ZqPD
         Dwjj6pezodZdAp0qqA73BKj4rMzGKjYmb/gW0TXHKxaaIuHtbK27lgl7t1h3yIpxmaI7
         ryX8W7lHdCVGxrZQVvPQ6Q7whmtbV1SnQzjHb83FCP14cFaxEbeo+K5wzMOYg34CbM9i
         DVYvvBKVIwHBnEFS8lt50b2d5XDxNdI6pX9w65/h+Nvr2m8ntWrZjfJuFi95L1doUWXP
         yCLg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791372276; x=1791977076; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e6PnbIvoXOZFv6pPRVmqWiNMYIregQMXJAxqLvuHzdE=;
        b=Pkl6bObzcosEqlKiYGPHrPCbsetJPaSklGV7cFL9srYf12zdpjvBLzm894zjBtD0r6
         IHyuaWfJj7CNL0AY4Zvvf1SAFSC2Vhfj7XqrgtRodTjJQOr2IcbKmQrLYtkaUsZwjk5k
         lFe2d5l1Qx1SIxbSJ+7icGV6u0qItDR0VN48Xna9sLm1aujGFYLdexFNuCkCDkVXbqNF
         3NUT46plwvzJKcu44dzm9BFuygS+hvDL9xpvhNSqFll4iC8GVfsmSx9MfDagWeVfsUSR
         BtOQ5fC4yCc5HUpVWacJNEcCYMspG1DPsFEhUj6VPJaX4A/g7NpegKO49ldvbhuT/Owu
         1pEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791372276; x=1791977076;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e6PnbIvoXOZFv6pPRVmqWiNMYIregQMXJAxqLvuHzdE=;
        b=MbeccvChPjYODoB+ZIdz1npqwbHmQNbio5R4HDzeig2KUnn79ruaiYG6GDECvaWyV9
         3GE9ovFvgjF5vC5S8HcAkZUmRcOXSy47MJxXSTJ+VPG8iVVUaeuucqPDVWYmG3TwwwNh
         ssFWyA3aYjRJn8bzMB0rIjMg6OndncXlrIoxwZyS6Dc0pJaEwVG8jPBp2QiTBizKxa7O
         8Vi7JcTLTaMNean+uPab7MHaOVM5rkPQMscdC1cTULm29IGGiMXaSlhtebDtVAZq31Lh
         3usrzQJ9Smt5PVr39stzjsnLRfzXsamEzN6tAbi37963b9dtgrJ3FLBOGK6o+BViy9+D
         fweg==
X-Forwarded-Encrypted: i=1; AKwUvBwr5YbZ6UhJyx+2j6+Zq1txZyt1V5e4iLxhh6wdzc3072wyFkzGMjyMzSy19FVOfKld1k+EvbA=@lists.linux.dev
X-Gm-Message-State: AFq9FYJTsJ9oKsvCyHjWbtEdHCYdckwe7SePvRSkWSZnR9Q21jhyhkQY
	AEdqhfrhx4tXex5ANdORtD850FceqSrlmnMfQ4z0X9jOgM25FCvrjtlhCkTHK+eZtcsSqmVt3U0
	lc5dPaUc0NqrkerWYcX2n9Q3QmrOD18zHhqDnPgSE
X-Gm-Gg: AYBFou22R1XHbUl0AH1dpqOXXc7bfcnjlA5Jqftrt5J5OKA9gP4+PilsCrZFKSXTs16
	iYOLicVG1FroYFLH9qYS8RGfU7VMYpmfkvC4uMn2RlY8C1t6W6mbQxE3QaT4EVuAxqDLQF6PzWT
	OUTC+58WcyRt/M1A8WlekC4JdZ9nbJ6TV/6idYFoXcWaI4gS2N7c6MXCApFBE1XbPX8BKq2VutJ
	GGnB13eNuo+FAj+D6eCFG6HpSNDJBr9VYrgBctesxjTfYDFhctiyvA67AKuNxWQS3YBrpOeqV5z
	mj8A2EoJ2IQLc9XFeOl741HB2WGhE5/6ati1hCfbGuFVcAw5tkLbcA==
X-Received: by 2002:a05:6512:3f0d:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5bcca857470mr320723e87.8.1791372275119; Wed, 07 Oct 2026
 04:24:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-10-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-10-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 13:23:58 +0200
X-Gm-Features: AclHuK-AkPhTBNuRx-Nil52s88bZX1XXziZHk8i7cIYK8SeGo6JUTxyL14CKqt4
Message-ID: <CA+EHjTwHBasTofGE5YQj0WfyN3v-uHykPxRL57AWJGhAO5Pojg@mail.gmail.com>
Subject: Re: [PATCH v23 09/14] KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 09:36, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> In preparation for adding VM specific backends for stage2 operations,
> nuke __unmap_stage2_range() and fold the logic into
> kvm_stage2_unmap_range(). Also, make kvm_unmap_gfn_range(), the only other
> user of the __unmap_stage2_range() call the kvm_stage2_unmap_range(). Also,
> while at it fix the comment to make it clear that mmu_lock must always be
> held while unmapping. The code already mandates that and the two call paths
> do have the write mmu_lock held.
>
> Later we would replace the logic in kvm_stage2_unmap_range() with VM
> specific backends.
>
> No functional changes intended.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
