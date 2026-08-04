Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADAF3A9D80
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 21:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785880475; cv=none; b=hmyE/iLt0eU3olliSNl4jRCuffNS6fIy7bUMTEYn7QRrOFmvRDPXI5jpqroFf1dIL8YbqTNxc9mNjnZmubxNUviQLh6xLZHP3aNcPpEIrfeVnIPmh38FGQsOwKrUfSQK6Bpn5xowdRAvbDuJ+Ropr/RB02gL50DdsTSRvImH7Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785880475; c=relaxed/simple;
	bh=IuHu+i8ykBGDsG06yppIdROtaxj37qLU5bgE3hYFvEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gy2L9Mg6SEIZRhYqI3qv1RrLx1z/cFWHpavjmXBbrjzVxIYyBgMF55U8gDZXH7oEPfjRxVM97bK2gbaf/DT7BwQHsoyrMymHzWMPpK98vk/Cr7C0h5USTrDX6YWOyULesDbF06qucS28yfaeIfxkVfKILvDpoXZq6XIJjMLEqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqRlzXn+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqRlzXn+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so2526715e9.2
        for <kvmarm@lists.linux.dev>; Tue, 04 Aug 2026 14:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785880472; x=1786485272; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9zdxL7pbRtsTEV8EC4r/5IgaNc8hBDEJjb1U6nqESgU=;
        b=jqRlzXn+Jgt/Q5ZeAmpNqT7D+0melZELw1b2w0F2eCay9yeiqzu6pdITs22dJXM7mB
         BVxqhuPniLN3iQuqv1Jf7f8HYEGJYOp9zR2xOKn9rYcNiCQzGWerfZ5ZOJRlZ5FGov8a
         c1KuZcUJISqLygnlSx397ynONffyTV/n7aV/Kw4s9G5VlW8ZsjzkWzMrjN0I9jkEpU7u
         vewC7GnAB1lbEV5S4AFtpi/WP8oZTFnWC7X0OfULNiumybeqpGgnuDkamVd0C/90Pqoo
         YLM0XGqN0zBuxe2Tm3wazoQPPvjurD3J7lzBSfgLiwztAzhzfOq9KufTXxkjz0BrVpZq
         qQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785880472; x=1786485272;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9zdxL7pbRtsTEV8EC4r/5IgaNc8hBDEJjb1U6nqESgU=;
        b=EObkblhGmFWa0stp1wwNXGfhCSoa62u1uIQs+avSzjDLr6yf9hZ03OAjkeMmj1gZYj
         Nwln+glm9FXNZglg/3yfQKNdzZueuz3kNU9FiTNxmKuJslnRQjELgnqEoWZ++7rpiQgj
         p7zIeGNWGH1d9HkUqxcE2jU5uf8g+bTNGW1ZGe/hIUQA62Sm0nl9OKlaXtZdgCl9SCo7
         MrAW0tA5vf4TTI3qhPEg7NZ49LLtfdpBGruA8ZsFSZ68sgT/TQaYe81P6ytzwMsjZQ8b
         iy52Z9QDCv5klNf70CDRDOlrTfO/SpoK0TL2IhGH2mOAdTnTIH9n9L+lwtfMNyE5+DET
         EAZA==
X-Forwarded-Encrypted: i=1; AHgh+Rrg35apePr1mqxA2mSzBOQLYRFJPpYQri2JchwrVQ/ZprnM6s+9iLTG8I6wTvvG3IDVYQIP5RQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy32rz/ptkNsgypW7bX7YScIAghldmmqqM+u+OArFmIMsTnatg4
	fkNOvn4ZCfjrvRR2iOsDQnq/G0eCqzBFju1BQXx5ndqm1svUbI5/6Op7
X-Gm-Gg: AR+sD13XjLZ/AL74QN83V54CGzMjD2+1xZCf4Qcdd5wLJE8io1jRQHwjer0l7S0m2yN
	dXVV+mF7gl4ebEmV5AMvSTFL3AZzUzcbzUUXJz/TQHbwRrfungdwoS6z5mFIE2c7vEXrrYvSZ4E
	zt5ez+Rwld6kDekbhoFHjdPyAd5QS1UEkcgv6yjhV+5dn2ED4ucIB0gUTDUzXM5GpapOyMQK78O
	fAkFs64nr2Wp/QQl99LcL6XaWrijpFr1IYHqHULmKGnIkqMx42caXMnglz4Ia6upM0UCH6u7wae
	NbxgM31Wf1mcQQXTj2ylPhNEFRE1yVPcJycWOVxzHeg5aSRt3do8UIjqZK2od9x4NDTxEHVGgPQ
	d70yOnRSy7MIwptj33J+/nCopwLtIBFCn4T+gB9zdpYqSO8fQ9hCQdwbeGlYylWP3JYWH1rbewF
	fvfa0iiz16uFJGuXYasePXzko1vma4Nvmgc9A3BNYSVlkxNMnksweCtDIPOY+DuI7MWvfbD7fuf
	SrnZtMxrSlOkdzIdQvKn9LznjzOQKQuTnAqcFMrL1DCXyJfh3ukQbUqdkW3+AzK8bxtAD4pjHfk
	9/3EmZxFaXi7CMuvET9OgWm7nktW6MG5A9EMgakvzloOv+Ga/mhLYB+V9WysaFS1J73EKIBX+bt
	tsb3yFw==
X-Received: by 2002:a05:600c:3589:b0:493:c845:bc20 with SMTP id 5b1f17b1804b1-4994e79ab0emr15048195e9.4.1785880471944;
        Tue, 04 Aug 2026 14:54:31 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a48b-1c01-1c76-d8bb-0f26-1c8f.310.pool.telefonica.de. [2a02:3100:a48b:1c01:1c76:d8bb:f26:1c8f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e980559sm10979265e9.2.2026.08.04.14.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:54:31 -0700 (PDT)
Date: Tue, 4 Aug 2026 23:54:30 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, grayhat@foxmail.com
Subject: Re: [PATCH 1/2] KVM: arm64: nv: Allocate the shadow S2 MMUs
 individually
Message-ID: <anJcUNlnNmP-mKWH@gmail.com>
References: <20260803224405.41468-1-kmehltretter@gmail.com>
 <86mrv2arf2.wl-maz@kernel.org>
 <86jyq6aq8g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jyq6aq8g.wl-maz@kernel.org>

On Tue, Aug 04, 2026 at 03:56:47PM +0100, Marc Zyngier wrote:
> > The other thing is that reallocating the pointer array isn't great. It
> > adds complexity, and makes everything more fragile than it should be.
> > 
> > See the hack below that seems to work OK.
> > 

Your draft is indeed a bit simpler.

Should I send a cleaned-up version as v2?

I would allocate the table on the first call to kvm_vcpu_init_nested()
and not in kvm_init_nested(), so it cannot leak if VM creation
fails. 

There's another issue in the current code: the ptdump debugfs file
keeps the raw mmu pointer as its private data. I would add that to the
commit message.

Thanks,
Karl
