Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58B9481233
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785945767; cv=pass; b=e8lUsiK/tt9n6sXRiBeufarHgM9aOcWRZmQgywlFRA+7WBGiBh6U7NQMG5GvOSsw5FUhfXO7wMwJmZuQw2QzacSRNYH51UQkRea5WSRMUNq65NZ0Oq+09eSh509Ax2wpqo08CUFCPuJkMoipua4e3UZ2oZsayeZPehKIg3oCqJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785945767; c=relaxed/simple;
	bh=urqjPATeIdTfgUOdfXyZZ1lXjN9fdXK4VUOiuTSdems=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJKy+R7kjB21Tb4XcWQZdmlb+rtV4nJpMntHvjRjKmS/EubhRyNKGnlWfxOBZ37wHX9MwGOStWXs+zHnprh/eERtE76iHI0GRVqAnop6JPB1Pw1KXFGXDrcLBjUU6IOEAAFFJhFj+6AsNlO0GqzLAXtagl9bwIGtt+U6wdJ0d7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OFbZjep+; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OFbZjep+"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceb096e675so15987315ad.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 09:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785945761; cv=none;
        d=google.com; s=arc-20260327;
        b=GuHqKaoCeRMApurxH8E5kzvJSsKLykykzYuauu4J0M8QGFdq1ilSMpqDpoH0CVheNc
         oI0kmnlFSvZDlWi0VhVE8U2UEGS8y/BghfagNhxmUrxzG34JdwK391AIq5fFsQ7HyawI
         3FcEn2504dJNY6yD6ZAMxUbkwws08mXVmkCmNnLwmdEylDyAUEvhLwA63Y1OkadNp0tg
         IyODhUYte1rgGQBidmW7O1E7EKM2qu9CjY5J20RLcyhmwSqeXrmxJR7q58brj+Qa5f+q
         XOc+QKrMCqe+oKq1FCQZxfML4tL6qiKsXwZRNY2zcFLf8q0k9aTfJCyHuYfFBcR3AJ3g
         11aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dDxVaJA0qLhUpRmzRVBWfrwvszjITp7kHu2WvQfbt0A=;
        fh=LJPIkf5jqO6lriwZ+PpRUtRJSJKAJalxMojVH63FfR8=;
        b=JRrjnW9Who89VOhNDIHIQOesjR3j1vZI/e52fEN1lEvA1B8HEckVsNEInIesCebiTi
         vKdPiaCZybvwYkir5si749MdxgTJu5iwcMsLbG+JeKyoxq/3zjcZvbwtxUjxwHlBjbH8
         4Vgd/Kw2bTOZknGKzLXvi2zeX+OjGaQm6L4Mkk2LPFTuJ0QtVh13VKjx6gqK0Bs4HQXN
         fA/E4j1lwlq6IymNPeVrDRdB9btzBEEl3jUndr1PlPKH0rJYzRZKoAKx55AkMlxQ86H/
         wuE9b05RHOmiRnA48i0CI80dIsgXO56xiCa620+71XGCtabpEqUfOvjwuiZe0E0xs58g
         KfQQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785945761; x=1786550561; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dDxVaJA0qLhUpRmzRVBWfrwvszjITp7kHu2WvQfbt0A=;
        b=OFbZjep+cS1htugwUXpD0pmSl5wJUInB5Nmetet7B7pB6eJSH94fKBrEEy5/jJD+tf
         PZXTVciMF/x9T5AE+SNEQxics/96AoOGcHnnGni8nQ5PYtd4x3Uiag7B0a6rYzjAn6yE
         QhKVOg6oh9M00sj3f3jX7YXVw+9hmCen7BarDR7PlJ175GuBeahBg2XRCN3UBf4ut2uT
         D4OA621LvFYqauIpu6r27ybkGoizs9Bac2tAcWnexEcqSJBBw2xXVg2V+BOueSgXOiTn
         x91JtLs6MO5IGQV4Sa9+qcDtUHU6AeZdAeCzfFcXdZXpSxBWUfockg3fp4N5sWHrzTyC
         G4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785945761; x=1786550561;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dDxVaJA0qLhUpRmzRVBWfrwvszjITp7kHu2WvQfbt0A=;
        b=AKmWw9KxFkviK+oYyq6CwZV6x6TiE2JJ0eu24eHcFkk+4sPEYbxntDqFSGoP3Pu4JN
         e8M0PrlY+o/UkvzxiCMH/68CcVqkQF05HliNET55h4GRymoJB1bFUjQL9zNjLANnFmuX
         GsgS/55WiX/jlT3f56slMsW8kzUvYQG6VqxpQCSjaO4VdmeRf2FuDqeIobk+n/uZI9qb
         GAoT7GIugxKjDOlUGHx3iJiL2wD9INp5yH4rfdfcOiz38uXgc0NAKPNKZkZUyCS6JZ43
         CaZHhjTaVnAmffzvlhgS3xOnb0tqboe23UZoCm0JHrnkTprFuCFS3W0vYG3oaXxILgsn
         arbQ==
X-Forwarded-Encrypted: i=1; AHgh+RqJTlUJRMgZOdMHDIXSTrb9+dxGrcQNwGCyzDKS5kG4maTzs7TJ9F/86ymGPIaDrSYbVVDzdKw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy6nlbKTO7iZIapsGMD893+R6uPGc0BFvmnTzfTc0FZZoussdK
	yxvxv2l2aGHzXRe/vlOxwMDyB+9uDantPAp1CIMCrInv82uTiRsT0cwbJ2yxIIgxrkxGPERoThr
	vyKl+WfXRZQFkOj+KDNUeKJahk9IHju6SmW4AfQDt
X-Gm-Gg: AR+sD13o5pctLRjq7Qom1Tfo3JpfSLQDeQ3o5wg+SYdyOGIuU+taClXLKKqzTOxiPa8
	6UQB3o8NY52G0giIrZT3AOQaIETD0Iy0hq5h81rBX1D4QPkPx9dr2WNQl9QAfOtzu7D0Z7bpHgs
	c26eT5GWnJhKCQi42wgXp3BibtWd+Sa0Modn9F8gSZesDeq5fN5igH1Hn7Q/f5Yp/tYmYibDcD7
	BpVSUq/mOtbIJA3m2e7dWREkyG/4y2jjG7o4U8cuXk1UxoET+CQslQOlu/PMGfOSWo7wIDR7CLx
	bUgsc4fcBM+k54ha42+itblnIBfKyvJJwbZ/lsrvrgTIymHEj0IGRnpfWTCQI0Ng/GiinKinTV4
	Zg7eFiFmh4JH/kmHy9b3u8LcoEnMtJnf9Ah4=
X-Received: by 2002:a17:90a:dfcf:b0:38e:9045:babe with SMTP id
 98e67ed59e1d1-3903c5589ecmr8554536a91.7.1785945758439; Wed, 05 Aug 2026
 09:02:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 Aug 2026 09:02:37 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 Aug 2026 09:02:37 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260803134403.80630-25-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com> <20260803134403.80630-25-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 5 Aug 2026 09:02:37 -0700
X-Gm-Features: AUfX_mzwYvzVqQkuKFkuAOMZ9a38FvddXqwH3nl4jjle1d5YB5Md9uRdePzF8HY
Message-ID: <CAEvNRgE5O4FcNQDHwh+DWsHH7gLs3qzm+L4ZQ9FHkt=WoTV2Hw@mail.gmail.com>
Subject: Re: [PATCH v16 24/45] KVM: arm64: Expose support for private memory
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Steven Price <steven.price@arm.com> writes:

> Select KVM_GENERIC_MEMORY_ATTRIBUTES and provide the necessary support
> functions.
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v14:
>  * Switch to guest_memfd in-place memory conversion and drop support
>    for KVM_VM_MEMORY_ATTRIBUTES.
>
> [...snip...]
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 15d42d1993bb..146c52f867c0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1510,6 +1510,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>
>  #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>
> +#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
> +

Perhaps related to Fuad's question about pKVM and CCA state: would
conditioning this on is_realm mess up pKVM?

>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>
> --
> 2.43.0
