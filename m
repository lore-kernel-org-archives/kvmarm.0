Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA04338239F
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753781; cv=none; b=G772wrvz0QaD+0MIjJqrbB46egAgA4iOSRk7J0gFEA1oAo4pcE2zph5A04cpa2JCmXIUvYMx+96cEcQZDaCVtOVW9v0rh+cEKej4YPP8wz9Pti80ixtwL6ZtA0zvlrBrFe61KMFne014+OUalbHceUvUBvuhaUhJgqrvh9/D5uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753781; c=relaxed/simple;
	bh=2f37lwrq/vfbI/Atd508xfmlAOAAdf/kzSySoRuzvG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWgUrgUZxC5xQ4Np8cLSi8fLD4RuPaiYUrQyDr3F78zDu3lvDkrlR8RFFSwIU8an19MqnB8Z+9NSF5iImFabB5rG+nenBxkmfaetS0QWNoYH0xmusLW23eXnrMhtWXxZLH89aiwnbzgFUaOU1/m028ARr+qbxdgK3PZSiAkjN30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZTNTnaFR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZTNTnaFR"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f6609c657so1622928f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785753776; x=1786358576; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JRwLB4+6t3H4PDGX6S9Qf/LBF8/KecqQ9VavQZhHs7c=;
        b=ZTNTnaFRFXkmEoIIjky3rbbAYw4egiIcasxt7UqbXnf+CKEEa3DPK7SY50vqO0OkEq
         7zRmB8w7TCCNn8rVC1PDbyLk+5+BZxKIsi+IKvn5WlamVwIYyw+vnhN+AgEF6m123v4L
         Dcm79Aoaz9+IoccNbHRO0hSXGLgvOatAYrin26Tv0soGloJQwYBBJlEOOTtIE5LwRXbL
         iomeliTD8c6CZllVZruP2/IKZuAt09jH7P9C1DLSdWf3QAQoj4KfignC1kl5wz8hUozn
         IWDV2LhCyMpbX5mgdc2gzNrkY8Yj9xngXYRvQJuKWE1nGuZb+W4b0bfPqp6Ow3zEw+R/
         lYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785753776; x=1786358576;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JRwLB4+6t3H4PDGX6S9Qf/LBF8/KecqQ9VavQZhHs7c=;
        b=HT95RifHJ4+sUeKantrwrAWUN4VV3jg/PYU0lW6UL38Hh/R8w9/P28WR8wyM6uMTjo
         vi9TgiXizzDXO2/aQfm7/RHqy85dpX/XP0vghZO+bY95uxgX+vDxxuyjcNCSuSu87JGu
         in4IBPk/u7K6HdMz4F5vCZ7Mmy/deideSZdt9SmODZNjtVZlrqBpA7eYOEZo/vSZX7OO
         3bS36p6lc0Vbtmwk7xGP6d8vZSWDmAg3UruRlLnFE5eDEddCIpsNnXYnj6EQJftR7+4/
         /pHWIiy+JXbBpVk0Yf6c0ir8Gs59fDYSEl58EqHDSbXLJH/30T+8DF9DwjQ28hiiCFOJ
         gqQA==
X-Forwarded-Encrypted: i=1; AHgh+Ro2Pxd8q/X3uwI38sYZ0qfE4u+MYTL3Wjyku1vFTgagCQBASnNZfWm17CHNwrt4+/Be2GdTL7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMMIu0lJVqQIqSMloEQ8gIRXQc9IMLhVMMWzZFYIGkiqU04/9F
	flnm2Zm5NaeLMvGrp1vJYZ4rsxBVi4bZnbRku2YggtrpsZ6BvciuntQMMavD2q1ALQ==
X-Gm-Gg: AR+sD12n8HBpg1V3tVXb7lFB8NMJwrZs/f1iNrEhT5ZNBSNKHC7COPIkaCd7R6/KVaq
	KCoL+UWPbzPTOpHI5PeVXkuqrGK+b1cF3ShdY1fA7wA6hPOv5K9B7wmvVSw+cJSBALLtKTI0r0N
	mCfpUiAeqcRY1dxOI04wr0VTAtVa83BFCWgtPNPEqnuXo+C3O5ci9d3eB2iOZ1OLfLMLB5ueF9x
	rd4JwzZyJuGj8YNhaEWCMQROt2WVhq/21Obl2/iJurE1rwJ9hM+5LqZhGb4HsqsrJXfnDTsxZVc
	lNpP3qtzFxauoJopVarTyAnwjh650cvXymLGhCFLnKS/WAc2hoMnDdyAC8hc9kCTjwmfWBPhhQW
	L3nA1OVetD5gWu0HF6RfbX9sS1SD7Ir1Mh+jq4dra983BTqJDMH0yIOUezll/qYaBJsJulgXE/F
	sYZ/Pg3qnhiO8Aq4O/s13nDULjYX8aU5FMelcPoyVb55Z/XufS/y8lBQGObVMPzUUxaYbhcCZUS
	2aNNXIffG/JtlGuStMPku3jpH7Qd8l7R0ZWW25XB73WR9bIKZU18rY=
X-Received: by 2002:a5d:6586:0:b0:47f:5b52:5579 with SMTP id ffacd0b85a97d-47fd72d4a27mr17326994f8f.18.1785753775925;
        Mon, 03 Aug 2026 03:42:55 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41e2484sm32978771f8f.11.2026.08.03.03.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 03:42:55 -0700 (PDT)
Date: Mon, 3 Aug 2026 11:42:52 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, alexandru.elisei@arm.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	tabba@google.com
Subject: Re: [PATCH v1 05/11] KVM: arm64: nVHE: Run the source checker under
 C=2
Message-ID: <anBwrPIILsaYWK_K@google.com>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720161343.1367007-6-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720161343.1367007-6-fuad.tabba@linux.dev>

On Mon, Jul 20, 2026 at 05:13:37PM +0100, Fuad Tabba wrote:
> The custom %.nvhe.o rule reuses rule_cc_o_c, which hooks the source
> checker only for C=1, and that only when the object is rebuilt. The
> C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule that
> nVHE objects do not use, so "make C=2" silently skips every nVHE
> source file. Call cmd_force_checksrc after the compile rule, as the
> standard rule does.
> 
> Fixes: 7621712918ad4 ("KVM: arm64: Add build rules for separate VHE/nVHE object files")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Nice, I have wanted to fix this annoying issue for a while now!

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index f57450ebcb498..ccc1fe8394094 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -49,6 +49,7 @@ targets += $(hyp-obj) kvm_nvhe.tmp.o kvm_nvhe.rel.o hyp.lds hyp-reloc.S hyp-relo
>  #    avoids file name clashes for files shared with VHE.
>  $(obj)/%.nvhe.o: $(src)/%.c FORCE
>  	$(call if_changed_rule,cc_o_c)
> +	$(call cmd,force_checksrc)
>  $(obj)/%.nvhe.o: $(src)/%.S FORCE
>  	$(call if_changed_rule,as_o_S)
>  
> -- 
> 2.39.5
> 

-- 
Vincent
