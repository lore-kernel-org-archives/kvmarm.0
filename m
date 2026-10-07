Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3D840EB90
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791382839; cv=pass; b=lRxER4zbEGJJZGl6T+/UdimYgvcyw9wWJPBgRL9F1t/WCY0rvhS+YmUqhGDe4WZB6xtskhWLI3GbcHrrWygGL8oYdPyKfRkOFUGjwBM5hClol/FzM+USr0pEhBfHvCE3tRP42nPv1Rbo44WjDG9v4fYSYaGsX2ndR3RsPYQLQE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791382839; c=relaxed/simple;
	bh=o3uLcb/w+UjgedlrqzsxP4CDLrNZM+eCbg0hqnND8A8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VpQn5vwctYNbB8NF8m9EZHUKpn66N2P+t+8r3dKVytoEKuRExZpfD8svpXaqVZRBuIAZd4e2CNt/6+7fOs/SM8GSO4P1Vfjo/dobhQV+xDfd38CdrK63y9adnOb3MnBq7oyw01thCooCrxY7WJOGoOd1tn/0TBuwOjqPQzEhklM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kx8Rlk6z; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kx8Rlk6z"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba40832934so7330e87.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 07:20:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791382830; cv=none;
        d=google.com; s=arc-20260327;
        b=oG+yaHXJ0vo6qW2Em47zecu7LVQOJk+qByHALyeC0Gjjh2jb/zrXMhSbL8qpjXmm9n
         7v2vLyxmC6+z59LPtXfio7sfZw1/JBPnDL+aWvR+9iNkTCtxxOv244Ix6v9tDYdQMhOY
         Yxd4YUePF5ixrdN/aIgcxiBQ4L0HPs68df6r7kHm22vnIGlUy9dLsXEa8yC1PpQdBqiq
         eQosUjwCaiJk3RJkxska0820hnVxBJ7IIA5C/SRLgq8cFfbrEB5ljdt+Ly3uDTaT6ZQo
         NgcIeYV6hnv+suAaaCm5CFmA7Y4SRNyCRiI2z3CRvkRAJWbaWpY9Ark8paxwMEWWN0Fg
         3/jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4UyXA6Kbx2RrlHyZTfn8yf8h54TNQENLjWNQqtxe20s=;
        fh=Y3nRVVYUccyTf8KiqYYzrnEpobpCUTEGJ7t3YDaLDlM=;
        b=FT/JV5ZZ0uSYM9xCXanyrJkdYWEkk/1cOWhnU7IPBxE/aZl+vqYyb3cctGIum3aI06
         DJUdUGP7ur37x7y/PKOOM+H+jckuwEWM/Em0oVoXH2mQyF2Mx+jCaYSyislPuq//3ry6
         0n42E8RSeHayjIAvvk+lvSNzCxIGSWSsxD4Q3+SZWu+S1cSvM/ugWN37dRiuJ8oRBm50
         bOnFSY6flO+bqQXuerTS4GM2w7Vlo9/cyJyMukxNs/d+asRu7/SYPdntAT4oQQiKbhma
         NVLYAgRz9gff7m8EDiFGsWcZykIaT+DkMmWYVnqQd5ea7+88uMbhfT/P2eZtJbgVuOp/
         R7jQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791382830; x=1791987630; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4UyXA6Kbx2RrlHyZTfn8yf8h54TNQENLjWNQqtxe20s=;
        b=kx8Rlk6zMEi0VrS/rVTh8aQBhI9mSKUQsl+JrYf+6aJf6G5fX1V1fgIJgkHrLPM9hX
         O2VnhJzXNAwJrwFTuG0dDAKC9Oa6alPD/Ed/MnGlpK0T01CZiigFZmWoajmk60lq5Biu
         A952O1POtXJ3ZkZQhM7jKrXjrucCUQA+3c7zbzuuP5fGaxyNIxTwNnnhetWwHYDveIWb
         hN6M9WRxrIf95tExd7d8EyK2lxJ9nPohfyDCoYThU7O4Yt/RhFJBQ+r+khUghM/F6YnP
         XAIEska+SnXu68yD5vzNpuiMl8Gi13mVZrFLYzypzY2KlD3vgbb2yXVa2Z9nuALoazQB
         wWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791382830; x=1791987630;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4UyXA6Kbx2RrlHyZTfn8yf8h54TNQENLjWNQqtxe20s=;
        b=udtLPC+OosqhqY5LQhl0we0cCP7xFFFfroZ7ly/gI9Mg+U8jdeoQI8kMwnghlayfES
         dJQEY2HO444lIyKQyMSHjUsUxd2JJNMEfzhy4Oh6Ep8FS2KAgDOIR4DSGNYIUfLfBiqx
         UbC0uamLRKLCBDrlDZu1qz7LQlydfrIxKnjS0qvCTwXfMUMd4h40yi+czWjdh0F8+Qm0
         hiH3hW35zsOr+1btJv1dl9c9MthqoHyKRdTk5sRRTYlKISfLPzmgP5W0JiOGKKTPEJ/h
         d03xiFnNxnS9fkhcQbV3CF6xctKYU0IRtXEqxy4sEEnTLwggKBkNDtKmAfsMj3XrJPUb
         bfzA==
X-Forwarded-Encrypted: i=1; AKwUvBxebt5xJ8fHjjOgqVv2ZtBwhvEuP6Pcut4d+CE73jSm3rdcDUizFkukDTaqX6f7vnAKSNJi/Sg=@lists.linux.dev
X-Gm-Message-State: AFq9FYI/y7k67L4NC8seLlB5XzhRBptlYVulpxGxygGxpLwPZBnzqt2Y
	Y3ciiYTW7W+cG26dNzdXYY1rrPrnlcGnsv9UOtK2Jm4EctA+otHYOPnBcSrhPl7uZ5B8qj3rADR
	wsCWWxrPJNGse8CmDD3efrh4caxzzGHqblQEAMmtl
X-Gm-Gg: AYBFou2zffbivlSjzG09MvtwvXvOKaBCfbK8MIXfJwuoSwrLbmNDD1kbL9clMswE06w
	t4iEwBNHzCILysut9KXJ3nVaKbu0lOJ1GKybIwyQfhSGO2Sxb7vXvGYBMyfV3+9RWR+iLLvaHDB
	5jHVnsUEUXw2D0d6s/vDk90/09Pwrs2x7p1P3QCIa3kMJttoWCfN76EHdcYiiyn5fCQsS7fYb77
	/vZ01ByA25NDLAEQOHVnDrOPZ8w8qGjeikMXV83IRTFvR98kIy3ekh6lIYjANP8pZ5UCG2qoaa8
	Agt1PDLNNou284olAILsssn5hNF7/GVG1u6/q3DWei3J6zOAfecrDcu3
X-Received: by 2002:a05:6512:1555:b0:5b8:ebf3:3370 with SMTP id
 2adb3069b0e04-5bcca158f5emr347184e87.5.1791382829437; Wed, 07 Oct 2026
 07:20:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-15-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-15-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 16:19:53 +0200
X-Gm-Features: AclHuK_RXJYhqf_nHqmpzWADAUDPbDkHCi_xcSBTNQ3epFkbXZUQQ8UXgywpORk
Message-ID: <CA+EHjTx-niYPnnRDvAAiY3MXLpSYau_PhiBTCiE9mOYUChASPQ@mail.gmail.com>
Subject: Re: [PATCH v23 14/14] KVM: arm64: Prevent unsupported vcpu features
 for VM types
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

Hi Suzuki,

On Wed, 07 Oct 2026 08:35:37 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4d0e6bd2009ac..97089c81d6428 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -42,6 +42,13 @@
>  #define KVM_VCPU_MAX_FEATURES 10
>  #define KVM_VCPU_VALID_FEATURES        (BIT(KVM_VCPU_MAX_FEATURES) - 1)
>
> +/* As dictated by kvm_pkvm_ext_allowed() */
> +#define KVM_PROTECTED_VCPU_VALID_FEATURES              \
> +       (BIT(KVM_ARM_VCPU_POWER_OFF)            |       \
> +        BIT(KVM_ARM_VCPU_PSCI_0_2)             |       \
> +        BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS)      |       \
> +        BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC))

kvmarm/next already restricts protected VM features through
kvm_pkvm_vcpu_allowed_features(), shared with EL2 (0b7d843ef3bf).
Could you rebase on that and drop the protected half of this patch,
rather than add a second list?


Cheers,
/fuad
