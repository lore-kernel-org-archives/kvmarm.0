Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618D24DA0B
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 10:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706782659; cv=none; b=ilOEPdg8IVho11KHuQZt4VdHaocqzQ/gU5iv8XvCElX8K7KVABx/PXBc3Zcm3dqng//MAUT6kEGStFan+uhIkvRAgbEb+Nax0fXMzf3u8uCIysVmViZ0cxC0d08DBd8QKpQ7kzlxKuMf0uMkV+9I9rRY9CDR4JLIjmOMPCh4Kn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706782659; c=relaxed/simple;
	bh=JakSA1SIkam0VDpcHM3yYmGak0/Ub8rhyhRsxA9Ahek=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eo0YXPAYwyCRJSyXMKnOP+DERgNdSPYwZ6aDE1/0/EGRg5gHOXcUQ9K/M0FzfLK60BOzv0htjwbMF4vZd9fPpxKpzd8RgfBmqclCOHxLJTwRh5Q2jo2cUHRf3aQAOy0DHphWk6n+JSBWf94AC1X6E7n+akNnBJ0gtWdusbJiz6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JLbGh9I6; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JLbGh9I6"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-55f0367b15fso961714a12.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 02:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706782655; x=1707387455; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SlK6soAmcqVG2ecR9BfQrWlI8GpaFdWOJjTghV8Nrt0=;
        b=JLbGh9I6Jhdw+rXlv7XF4orvFBQjDJXsL8mFWKsSnoQaDtiPPRtXnv6xhArRj4DXg4
         YZ3OMpl3zLoMZt2LCtInVct0YsAJ88tWTN+C2om6aQ+dndxXhOfXNNBGjRx9gVa6jNx0
         coZIi590PAdKm0Ecc0GcySS9myIq9wydLS85oMiH8JfIDZxUShD3vVAMqND4ajfQ3+zH
         KUCGaCnk62FfjEb4fzUQ+G1+BBpA4tWyncTiRK0tBviixeGbI+PvHHHHZKwAIJ+WucNX
         eWb3e3Z7B4J1VVteaffQm3MKIEZFYcIQDuybLCsBn1DpvYmXh02dFAB7u+CLJ3WPbwST
         S62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706782655; x=1707387455;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlK6soAmcqVG2ecR9BfQrWlI8GpaFdWOJjTghV8Nrt0=;
        b=b1LDJ2wakstnljE8zj3W7M4asVDnpG5QHzFzDMtmi6YuxjJgyUAsBd0H/SayIYJL7T
         /zLu+w4lsePHJp2zyIV4KMjJYu26woPQcLbOt0SeHtjYPm8rPJtioVkZfdmdjWPsLuT4
         OaluF5tEWYSjB310u217h76LyJjFleXhq34aCiB/lBfGhI3HRjEq+nuOh+cpCT+rpDLL
         XXBQi3yDRBj5yAUWQiVvuvZXvL1d3ZLxvVmB2Xm4xTnjkR6FM1vEaq6ed1CS4XKmGyxq
         /C1ekZYYhLKs7O2OBAWfHnGauhP9nRTpbtMsdWtNzWQ45lqdTiRru9rdLFtgt9/aXDcF
         Qf1Q==
X-Gm-Message-State: AOJu0YyNM9WeU28OplqxgJRntKMfXaz5zpsJPIjikMbJ6jWYB2kUPHJE
	PPrDChtaHPznfFF3XrEfWITL/s+bzkoEqLakd3zt3B1RXNbWCprPx5VoMeLSVP8=
X-Google-Smtp-Source: AGHT+IGTquJMFOjWVwcDakJ2/kcpTAoYul8ecE3kBTsNkbEcKEEHYJGC7e74Gkfa7iLMRrB+fSVg7Q==
X-Received: by 2002:aa7:df0e:0:b0:55f:acb3:f9e1 with SMTP id c14-20020aa7df0e000000b0055facb3f9e1mr1329974edy.28.1706782655544;
        Thu, 01 Feb 2024 02:17:35 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id g13-20020aa7c84d000000b0055c1433be60sm6835389edt.50.2024.02.01.02.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 02:17:35 -0800 (PST)
Date: Thu, 1 Feb 2024 13:17:15 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev
Subject: [bug report] KVM: arm64: Always invalidate TLB for stage-2
 permission faults
Message-ID: <1479cd6b-a10c-4459-8b34-318865cb807a@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Oliver Upton,

The patch be097997a273: "KVM: arm64: Always invalidate TLB for
stage-2 permission faults" from Sep 22, 2023 (linux-next), leads to
the following Smatch static checker warning:

	arch/arm64/kvm/hyp/nvhe/../pgtable.c:1342 kvm_pgtable_stage2_relax_perms()
	error: uninitialized symbol 'level'.

arch/arm64/kvm/hyp/nvhe/../pgtable.c
    1319 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
    1320                                    enum kvm_pgtable_prot prot)
    1321 {
    1322         int ret;
    1323         s8 level;
    1324         kvm_pte_t set = 0, clr = 0;
    1325 
    1326         if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
    1327                 return -EINVAL;
    1328 
    1329         if (prot & KVM_PGTABLE_PROT_R)
    1330                 set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
    1331 
    1332         if (prot & KVM_PGTABLE_PROT_W)
    1333                 set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
    1334 
    1335         if (prot & KVM_PGTABLE_PROT_X)
    1336                 clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
    1337 
    1338         ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
    1339                                        KVM_PGTABLE_WALK_HANDLE_FAULT |
    1340                                        KVM_PGTABLE_WALK_SHARED);
    1341         if (!ret || ret == -EAGAIN)
--> 1342                 kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
                                                                                    ^^^^^
level is uninitialized if ret is -EAGAIN

    1343         return ret;
    1344 }

regards,
dan carpenter
