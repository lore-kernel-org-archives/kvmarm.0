Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB181DFE8
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702672; cv=none; b=R5iydKn/QoeY+USfjGh2gGoveNoo0u+8gYI5PsXsfgLxpU0zP3u7Ogo1+gtj8Upy7kQa4qCjQFXnv54n2j6gOik/3kB2iOQHpHw8mj+tpwDJPozBYDWVebcYVKW+BmS8cECtBYHSqVH6SGLUaTvzSx5oL7Hagw1wWM8lCoI++1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702672; c=relaxed/simple;
	bh=qM29SkS5o2wfxy/5l80wfNAUyeavrf9BVcVfOkwKY/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EoLPdRdYhmG840TOfEpJWio28mQgBHLMln+BoG5nir7+53gQVkr179RAnw1MStFXcJVjLPBz9SlTrix8xKpZsYKWoYDkgLtr8vp5YoScVyvM/QnWvL9Ygd5KpoVRW5zuzvMS3pSay+umdwUTVTGnWSGHKzQaHn7UemLMBu4VlDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RX5GWl/d; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RX5GWl/d"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8dd488e09so5539583a12.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 15:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712702670; x=1713307470; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VH/UmEChwdyjZ/9aT/KUw9UQuyTiVzbfxn08LZ7BSrg=;
        b=RX5GWl/daCJ63dLDhewmItzNAqkEcIy90UCjwE1za/PQVs29TuIhByjCKfqTrP4cQB
         NpVKf4q1LyJlF2C3rBEcxa+HE5cQYLwbD4/qeu9taz3zzZAalVN9seCT1K15VH0zfNwW
         MP6fhLQH4hDZPaexwWO2d3YaACijaok/kZ8tmcqZl0TlfjihBoUGwcgYA9rBJ+ZCFliP
         m0JALTOmS0lu0/9ssf9CAbojmzdfZL/Nqv+jsSkKpKy36LGOB0zSY1sygQpumzYciqSD
         o53eq0kpEI8HzLS5rz/hsk753op1xYW8XNfFfSwzrsGakkyg7eewoeHjL/DcWK0wp7f+
         r/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712702670; x=1713307470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VH/UmEChwdyjZ/9aT/KUw9UQuyTiVzbfxn08LZ7BSrg=;
        b=xQ4GjlB7nc8yIYpjmuhFOiuaE3pUV2EEpj4id8K00e8nuOmmk2vNPrBGNL4WlQ01fk
         5nF/pOsZJ4g0+W6oGIoWG9srETrs//1xL6sD/O2jYtwrmdsbGs7bzvXSSar6um+GMs8r
         huJBV8UhMX2mLN5BxXuFzRx8+gsWO4B7ZWxuB416H7DQUywkfpelE3wrGiz1+35aLI9T
         QnAQT7ExZNXZ03fnylCnaJUtkwX/prLGUVh9TZP3YoitcK4F+CfXYQuZfDpCiT+xhRz6
         YAqJ4wS+2mEPWIkWNv13LHHChurcN76qXOmnYFermR4Q13xm2ZGlHn4nVqRS3DHb32o9
         bc+g==
X-Forwarded-Encrypted: i=1; AJvYcCVQ9+I8+L0etnXXgIUA8t/7WTAhtvYuKTLyJKJ1WHlolfELV/MGf7FL+P1KIYUtMOfMW9JKbwK7dhKCUDIXY/VER4AAONpi
X-Gm-Message-State: AOJu0YzQQzVBxmii+X8EcENrPhaCcFaigsF65tXEDzyTnXDCPAPr8pNp
	7AicxBWiuWOHTu7GvJ51Rz8zpXtkpXdGnnYFc2W+qIlQMT6ySoDwQVndaQ0JHgajlraZbcxUREz
	eDA==
X-Google-Smtp-Source: AGHT+IEKcTUQbJF7HcWLxaLFN0XfKlKXAruCoVy4SPhA/1+pHY/GIZSslF6K8fw3dj5zJXbZ707++dbd2JI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5c88:0:b0:5dc:14c9:64aa with SMTP id
 a8-20020a655c88000000b005dc14c964aamr2813pgt.3.1712702670100; Tue, 09 Apr
 2024 15:44:30 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:44:28 -0700
In-Reply-To: <20240215235405.368539-5-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-5-amoorthy@google.com>
Message-ID: <ZhXEzACz-Z2ruLaT@google.com>
Subject: Re: [PATCH v7 04/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
> duplicate the "if (writable)" block. Fix this by bringing all
> kvm_is_error_hva() cases under one conditional.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7186d301d617..67ca580a18c5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3031,15 +3031,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>  	if (hva)
>  		*hva = addr;
>  
> -	if (addr == KVM_HVA_ERR_RO_BAD) {
> -		if (writable)
> -			*writable = false;
> -		return KVM_PFN_ERR_RO_FAULT;
> -	}
> -
>  	if (kvm_is_error_hva(addr)) {
>  		if (writable)
>  			*writable = false;
> +
> +		if (addr == KVM_HVA_ERR_RO_BAD)
> +			return KVM_PFN_ERR_RO_FAULT;
> +
>  		return KVM_PFN_NOSLOT;

This would be a good use of a ternary operator, e.g. to make it super obvious
that "if (kvm_is_error_hva(addr))" is terminal in all cases.  I'll fixup when
applying.

>  	}
>  
> -- 
> 2.44.0.rc0.258.g7320e95886-goog
> 
