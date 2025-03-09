Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A01F18787F
	for <kvmarm@lists.linux.dev>; Sun,  9 Mar 2025 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741507896; cv=none; b=CVycQ3eJMzV+2vxn6qpjo25UQsOx/VLXXFYVEIwbAQtFkPrWdm96Cq9N1IJCojRFmVZ/u6FyKr8ljb53m2CUsdHFi80BKrTT+1uDMKdNN8t20jNjxD5lm5Z/dnGyJYMmWst6Qi70MBnCK2e5eyyc0Mxa9SwlvtMNSSqSzER5WqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741507896; c=relaxed/simple;
	bh=Q6rj08KDrui8ypRPR7Rnc9Y9uhUc7RHUmj00WT8Y1T8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UooBfhkAnsNWUw0K8/0S4ZXOoIcRVaOtfG7aoF/euoTarM4hjmliBnc46tHWOR3YogAm4RYHMfve8gvhvlfeapByv67RF7WKVBXjtghwAJhqZSrsSaJqzYLASOUvHWbflWVMejj90GsscL9ejzmakT2FhzCOaoxZMndejYkoitc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SO5xdY73; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SO5xdY73"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741507894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6D4nNiDsoCmfkR08WaPZur5Udci4/JXP8lfXTACJmTY=;
	b=SO5xdY73RFOXTmLD/kP8ND3Yqg9Cxb4V5W77Pk6Pu+Fo48TTDm5UNXm4H4ReLd1rKCkZkr
	S9uW6eIi2HcER5FFh5GyvZdxnaeMHRq2hEATir4hNC2vGCB70t7hodfnd5EzApvX5siUOH
	KqVl31sHZyp9cWWjGF1v6o6RsGJ63ZQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-u2bUGZsVO-Szi_RXLq3uuQ-1; Sun, 09 Mar 2025 04:11:32 -0400
X-MC-Unique: u2bUGZsVO-Szi_RXLq3uuQ-1
X-Mimecast-MFC-AGG-ID: u2bUGZsVO-Szi_RXLq3uuQ_1741507891
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-391425471ddso242750f8f.0
        for <kvmarm@lists.linux.dev>; Sun, 09 Mar 2025 00:11:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741507891; x=1742112691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6D4nNiDsoCmfkR08WaPZur5Udci4/JXP8lfXTACJmTY=;
        b=tCXMmrNJzupNkRlzGGYH0E0msvVxoPJ5TQAcsLf68hlpEXTwDpV37LmNm/yJQxG9LX
         DCIG6LsTGj7gNgxFYcfiURBS26HC7/LjgOUCPG6FXFFFXZXc+2pj71WHdjRsyyxOcgrN
         XaqPP6N42jTIKUBiWr+S1Mn8zTB6cQl4fPObnGTKoiXx7i+rAxn9rSrG9Il+P3A2MkCa
         zeWeXVxz0aSR/9avQL13RXQd6KrQaPGORi9ENpA55QUofpGzgsFOWyEqFApwoUJCq83f
         RkOVBW7FRYQ+Vw2xnivTC7/ezqxVlcqt6K1ktDZetKWTxaBNlQ+X0JM2bjZaqWDreVI0
         Dxvg==
X-Forwarded-Encrypted: i=1; AJvYcCWDHDAP2QupNQh3kJzXvv6zAwTes1vP+KOXwUcIPsrzBZPXzlp5qIFIkBhma0PHZvoNmE80XnM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNPnOke3e8U/UBEVnMiCHmAn5e5MqkzFjHegd0ifwi3OLHVP8c
	XV9vTb9wafMW+P7KsR6DuuuSc09lNjQQt8ryplSj2u+L8FFo60AMCUzkjw3dJIv8vWgCtshVEqH
	P7v919PFqzVmfS7AP98WCJYLT7B4+e87cFKAWXurd6irXxTG85GTY0qz/lXlDNSWb/7MUrAh8gZ
	MzzWbK6zmBXGbQrYGRezjefReOLxzc
X-Gm-Gg: ASbGnctvkl/4ZiZp6e0wsh3DW+T29/l02/RkSFgbJuJdarVzaFP+dzFH1ICggax9NN+
	e7smrb6YxyucFhsW7kEDGCga6MKqjiZprjzAaFkt/LgdWTeE3JMAHtW2LXKt1W59STt0iRcMk7Q
	==
X-Received: by 2002:a5d:64c7:0:b0:391:11b:c7e9 with SMTP id ffacd0b85a97d-39132d6011emr7166826f8f.28.1741507891078;
        Sun, 09 Mar 2025 00:11:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiBPbgntPWPglpyH3yVJe7DtL/SqQ3tkdVqB05cSWbb15hmPwKqmctjqE5FygFtKO8OhuBCU8t4eAyP8z/ofw=
X-Received: by 2002:a5d:64c7:0:b0:391:11b:c7e9 with SMTP id
 ffacd0b85a97d-39132d6011emr7166753f8f.28.1741507889227; Sun, 09 Mar 2025
 00:11:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307161824.2373079-1-maz@kernel.org>
In-Reply-To: <20250307161824.2373079-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 9 Mar 2025 09:11:13 +0100
X-Gm-Features: AQ5f1JrP7IQ8OrSLUcslcCFYIM4kkq22dH0_bEGdv3OXLIuy8ZkTPSuW1cy68r8
Message-ID: <CABgObfaZQsPLvyYsuFzYJOwgEaJ40=yZ+TS29Lt_xZyT9oSKpg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Ahmed Genidi <ahmed.genidi@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Leo Yan <leo.yan@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wevwHu4lbgm7YqYSDk4VV2x6u_laIFtSxB_nGUIioO4_1741507891
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:18=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's what I hope to be the last set of 6.14 fixes for
> KVM/arm64. This time, two patches addressing the two side of the same
> bug, where pKVM's PSCI relay wasn't correctly setting up the CPUs when
> in the hVHE mode. Thanks to Ahmed and Mark for fixing it.
>
> Please pull,

Done, thanks.

Paolo

>         M.
>
> The following changes since commit fa808ed4e199ed17d878eb75b110bda30dd524=
34:
>
>   KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2 (20=
25-02-20 16:29:28 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-4
>
> for you to fetch changes up to 3855a7b91d42ebf3513b7ccffc44807274978b3d:
>
>   KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu() (2025-03-02 08=
:36:52 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #4
>
> - Fix a couple of bugs affecting pKVM's PSCI relay implementation
>   when running in the hVHE mode, resulting in the host being entered
>   with the MMU in an unknown state, and EL2 being in the wrong mode.
>
> ----------------------------------------------------------------
> Ahmed Genidi (1):
>       KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()
>
> Mark Rutland (1):
>       KVM: arm64: Initialize HCR_EL2.E2H early
>
>  arch/arm64/include/asm/el2_setup.h   | 31 ++++++++++++++++++++++++++----=
-
>  arch/arm64/kernel/head.S             | 22 +++-------------------
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 10 +++++++---
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
>  4 files changed, 39 insertions(+), 27 deletions(-)
>

