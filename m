Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3444B67F
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 18:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435143; cv=pass; b=OqMNFdOy0xO5qIqA/hyAeEAvQU3PotVpFcc/ht/CG1yDuwbdgD1Yszt+SPOSJ9acHSY1ep3/Aufnt07p3WjtmcKH0E0VWuR2LEbLT/5bVq3hPdhQoEMqtlT3B+0mVyKjSXqk5RMgmKjDSsRpCnL8J3e4ngVh7OJrTEnN19HzeDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435143; c=relaxed/simple;
	bh=TfIMwScvckB1Fib5Y+wsX3mqgKnQULjNLMCYcEOof2g=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/o6gAUGlgjHXjbDy7oUitPT0wh2sUTmptuBor1YVc6tIyWOFDaBsbNSFoGHPiQbmYMUMEQ/5gJGq0NtAVlGnH4KxOxljTFqwK5MSmlxHy4FOO2R0OTBP/HJWuhOC8YmPQgIh61zu1CuTNy3/VTzhvPXCRjtBPXDrN8Q6Z0i7+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BRXn+5ad; arc=pass smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BRXn+5ad"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cb5a6aa8760so55673a12.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 11:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435134; cv=none;
        d=google.com; s=arc-20260327;
        b=nL7Jd/WQyR+P3X8QbcyFW0Ndfx/TqFlRs7uz4gCltwe3gReh/DDyZq0T6hf8heGCOZ
         TsYaO7uiMg/wcYAh8J95YEVM68/f8n++xS42h44mtZmK6vrW1TAEaKRIyAKHRl1FYQVl
         9kV82cn9yILxgB4KWW+DkY4D1HxGl43Dcs85hz9VpR7D090z1+RMqz7EA3ww2al9G+Di
         EzASR8M66i5hTpjKIlgeQdffFZL9uTSa8Bs3MBpFlIPJw7pWsLGmLladQKRte7/ZXDAJ
         5LkLTyRUAWQqu3M4XJJTSqpyUf5gMkOLVCzG/E9qp3z9aXHqsaRku+yOMMg7jZffq1fg
         KWWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
        fh=ppWudZ0y4M1jtjulm473aF/NXjr0nVJnRBIsh1vd8Nk=;
        b=Yl9aJ9uPQSDFuTlYH0i8zP3Vs7lBH6ibgayiuzyzlA5cAd20CNUtLkz5KdvMLKnuik
         duKD/CJJLTv10bNOKEIjIyvhazlgvb6j+PSyy+a59tg2w2NshWfM0gyuNaTvdCKzsqVs
         ziY2F+a6EEzkXd0uHEpyzi/5iGDRLhxsHyuLDyXbzBtL5IDye45Z/xSv8YdBp6NyRUzJ
         K1HDGnfgXU8NImZJJlgbudzfB7Qp1swqNIWmwoCdLKKQM4AQJ5pQWrwvSEtxs3XQX+CF
         hgB0hDglaIhKrRh1qy/Is9QN6Ts5fAqlqzWJjewCxzW13EtPXG4VM/GezN4GFCd1uxRb
         GfGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435134; x=1786039934; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
        b=BRXn+5adTpCVzhJgQvUOPTi9K22n09V8S1U0zxXNbeQOjuQnJ5XqddnfOT2tDkRaeV
         Czzi/Vxuhmb3PcbbZA+zudp7bZQXaNiyezWaRZXOe04BZ+Z8BGghGMTUR2FwYobW12fR
         fyOXUsHT/U7M2W0elD4h4rkbIUgse0b214O+yIlb85OfzhowfwHLldw+kudAYO57tgy2
         Lxh62ZcPkl6I34yA2W66/AEq7W1X6My205BMoZ78yhqkIsKPUmUrBnPbfO7Bxaa9S+aA
         NjBqpQvcGpRAPaL+4JBHmR15D58Xds2roGCtp/1dTfpFYoR3Mw5YtpdJKCRcK39wyS/k
         XAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435134; x=1786039934;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
        b=O4RYIcKd9LFeqOyyK2foFB41Jj3hJdMYTJ9ZBDk7wXrkj4Hz4mH9BIjIdRfYITID+F
         Wzf2zclQ9XFdAK1MHuO8LxVwRaHMskmj9SW6bdPIJV26p/mXETFtTeSGrGZbakVx7ggi
         fY9IMSgXmDOs+vDvpqh81o3j7e6pXoJOgcMOr9dyU13UTDRxUZa3AvmWBXafTGKXra6j
         +qMZUD0rhZ6UkyWAToieXDAHz2WnRtyzj32ZinvUwLZIxOVJUxx1Lolm1sWt50ATIIZo
         TqW2vX8dROAfXDWtL/sBKI0n9qp1ahhshPbhxfz3UZwcKXzoUtt+zqKjo81jJOMa0Nd0
         zujg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9yXAw7zSSmBx7RFSVhsDF44iy4Y++6pKHOwWP7GekE/LGtzs6OvbZ1nWK3I6f+fZx7wjRceU=@lists.linux.dev
X-Gm-Message-State: AOJu0YylHCUpT9AnaYBLxnzDDmRRZBhmO18z/jR6kmMrpENrl8wfea42
	l169lQ4NmgpEj9iERc63THG8QvB9kbTEWag9Hmg9S8rlnxUo+dGifcsvW7L6o8eq2vvoZKcGSKg
	vpCWSVv8LciifoYzl/qV83wyGmesi5uEIcRvyjF6R
X-Gm-Gg: AR+sD11I+uqDFYbPj4OmDoymJZfQK9i5OBgdjl3Vthwv89oU8TgDHINAx3Wcy4V5KcK
	0daM3CvjAb4QpbfTgxRpOJ1RKNoOFvMozVx2O1m1CJUwfd449S34O5ehjuP4vDG+YnF3LpDRrS0
	OWal37Ji1SPbfyAzsuIf4JDC+l3aMvzYkt5Erhx/UmcKXoitcvSbisFkMnCqoo9ErsyG/FP7aPn
	jft/AbkGxZ4to3E1lnkcTyYsYmngKET69697XdYq4aBMuhxPRNon4ZdV4AQLfV2lJQ+QMegbcne
	9vSKk/b7pJW4q1HbjfULyCssyoyrM2O3Zt50bvdNL2NDAoy81TlMKaGS2Bw+aTH2W6CxWMSzhiA
	jLJg/qQlgslQUaf2hpOqzLijni81BRt5qnQ==
X-Received: by 2002:a05:6a20:7f95:b0:3bf:9b61:f7ae with SMTP id
 adf61e73a8af0-3c90046cff3mr3701207637.14.1785435133085; Thu, 30 Jul 2026
 11:12:13 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:12 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-8-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:12:11 -0700
X-Gm-Features: AUfX_mx2gL8KIE-6PLoUtXVMOZbkrQaxrGgfvvgdayE505KQfySpbra5kxUa-V4
Message-ID: <CAEvNRgHW0P78eL0ip799XF+2geKwz7MQrjSFTgvCdUAuh9oykg@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Tarun Sahu <tarunsahu@google.com> writes:

>
> [...snip...]
>
> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>  			       loff_t len)
>  {
> +	struct inode *inode = file_inode(file);
>  	int ret;
> +	int idx;
>
> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
> -		return -EOPNOTSUPP;
> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
> +	if (kvm_gmem_is_frozen(inode)) {
> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
> +		return -EPERM;
> +	}
>
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> -		return -EOPNOTSUPP;
> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
>
> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
> -		return -EINVAL;
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>

Continuing from [1], this guard is actually meant for PUNCH_HOLE... I
wonder if there could be a deeper refactoring to check when actually
punching a hole, basically the equivalent place as kvm_gmem_get_folio()
in the flow of fallocating.

Will srcu_read_lock() be taken in a nested way for the fallocate case?
It can be taken in a nested way with some intricacies, but maybe if the
freeze check can be done just as the folio is about to be removed (as
described in the above paragraph), it would avoid this nested locking
here.

[1] https://lore.kernel.org/all/2vxzzf0kl3dt.fsf@kernel.org/

>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
> @@ -291,6 +316,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>
>  	if (!ret)
>  		file_modified(file);
> +
> +out:
> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>  	return ret;
>  }
>
>
> [...snip...]
>
