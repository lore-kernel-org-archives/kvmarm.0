Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B207F471
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319607; cv=none; b=j9j0OFQj1o5XU2RIsSREZ1Sj5XSW4mCW5k3tkKMkhd4dTVF7zIWYC+VQ9BL4ytRIuOeAd6Szw1rvoAZmD/8qtccuX4OHueX270zVcq0xiPSQnX/W30a5+ywJOMny+0KMUhO+e+vRFtGPSS6f+E0n0SYNobdTvnvqigIo0yO77kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319607; c=relaxed/simple;
	bh=nBf9bw3jxqBF5jqhtpbO9vc/13Y/GXDtSQyt+7JsL4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G1+UJ+Gpe8/cEfo1plmiqtrBvkoT3yGa6RXhaSLjPx7LrPqgK8aR3bHoO71U6yk6zDOSfUfxn5f4vQHV51xbxNbHU7upJctpCUWT9b/M8B4KwrH1l44kZoETYPwZZx8QIPP+JYOYWCL4SF0zWt9xD16CfhWLQmj7alrC2wqaKxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2jgueQN7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2jgueQN7"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f6c12872fbso13564587b3.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 07:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707319604; x=1707924404; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IrStt23DMMWYh0ENRShJKd9wb4dk+ZyCGtr69LJbA0I=;
        b=2jgueQN7e42+OOGVGwbDpbsgRi7dwR9EdfiWuE8inMg6SG85AxHaooXnhiEZRUPBL3
         EEkyMRSvUYwP2OP/iN1z3zkz2tNIAJfmOx9TjSmYMJn5/2wNzwjvzP+gWtIeDViwxM0k
         uF5ZNKvPjzlSxp0OaLpthz0mVDG/8UD/lKRRBylCzO/KySkxr+9K4nlCrUy3262E/He6
         d1VaDcC13v5tLyhn5gtbyCotJn9yt8o1BN/nRZbdEA2gdPISrhGUnwhRAtcb7bZQHdLq
         rv9ob1EnprsZk4h58yMICpjvJ5xF6zaK48W0ges/NcKmEfGPlh0UUCqN8zT07c87rZsv
         5lhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707319604; x=1707924404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrStt23DMMWYh0ENRShJKd9wb4dk+ZyCGtr69LJbA0I=;
        b=ticu/eKQCbpMK0LOA1z06KTw8lJl5IKDkoBImMJsMJ+Xy5g2rJGz1rFWLlf6FDaIZN
         DLQghRF2rPSLmUB+Tk4GV/8ooj54Q0uNfB80zwwHq/1Fth1BxkXMYpZCyg4+yEoevxh7
         OunIWMgsz6YwcxS9bM8j0X3V422Gmnp0+L9yme11ruMONc3XeM9u/RjDSiCW88+3waOy
         IOytgdtlBpE9pShv/jiyOPmaI0DiFTBA1QyqNUannMxRzORNfK+TPC2Mx5l9GmIWv859
         Q+821lye3QBZcBMa7f3QXIQsg4Dfe4xc65vPkULKJNlqa2tWprEZdWywm5YG5EBTjbGo
         N5HA==
X-Gm-Message-State: AOJu0YwuaqiF5Tcsh4gA+BAYgZRRc+wXutrd9n7VkhZnEzAR3ETp2je6
	WKgIlZ+9c0X2GZe/ke0ifPjP5BV4OkyKV8l1rz+sfL6teQrRILkg5+42qZTplSd5LKWYScMUL5u
	3QQ==
X-Google-Smtp-Source: AGHT+IEprpVLHFnvzBSR1ktlp4D+f+yjpL3NKCZ0oafSWw9HVwyAwVcOgf6rQxEKnnysFCmQ3AbY38khA0s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9b87:0:b0:604:a0e:f659 with SMTP id
 s129-20020a819b87000000b006040a0ef659mr878219ywg.6.1707319604705; Wed, 07 Feb
 2024 07:26:44 -0800 (PST)
Date: Wed, 7 Feb 2024 07:26:43 -0800
In-Reply-To: <20231109210325.3806151-2-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-2-amoorthy@google.com>
Message-ID: <ZcOhM5wPguyNC0j5@google.com>
Subject: Re: [PATCH v6 01/14] KVM: Documentation: Clarify meaning of
 hva_to_pfn()'s 'atomic' parameter
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

This is not a Documentation change.  The comment might make its way to generated
docs, but this is not Documentation/ and I most definitely did not expect a change
to kvm_main.c based on the scope.

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> The current docstring can be read as "atomic -> allowed to sleep," when
> in fact the intended statement is "atomic -> NOT allowed to sleep." Make
> that clearer in the docstring.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9170a61ea99f..687374138cfd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2983,7 +2983,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  /*
>   * Pin guest page in memory and return its pfn.
>   * @addr: host virtual address which maps memory to the guest
> - * @atomic: whether this function can sleep
> + * @atomic: whether this function is forbidden from sleeping
>   * @interruptible: whether the process can be interrupted by non-fatal signals
>   * @async: whether this function need to wait IO complete if the
>   *         host page is not in the memory
> -- 
> 2.42.0.869.gea05f2083d-goog
> 
