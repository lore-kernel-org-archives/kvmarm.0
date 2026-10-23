Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742515;
	b=5MvEDORbGvnpO1YG5CpRRmd9RAwYkgwnV84DR0QcexsXhEUb+8s9Eh1gBkfkLpZYC14o
	 ARf26IMafpgeqvI97txRzBRWp8687Et14SAkd5dgR2Xv8DY6plZzcXQw2GzLrhbV8Gno9
	 fi9FDD9mAnGExwmledELAWuYuDmivatfvkqoItnfdr3ogaDt7AJrA7w8N9UnaMl14M27z
	 v2jSz8uoexlHUvEPp/sXDP5FWMxvf+c96BAB4z1eiz6ZNRGDvTxDD5PcU1YREVO3YbXUv
	 yY219as9knLcxHHqbv1q+2Yfph6GQYCnUYps656c9vqdiE31R8sXUYnay29FhTSVDzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742515;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=h/NfMB+35she+i0TxY4peuXbshaf1B5IwLQii+ni3vw=;
	b=so3RLkXQUG6n1uQxb7uT7dkknqISfxkXxlhijI2HSijnEs2/qepFKcdcSGQXLUzTfIYN
	 ia9vZtu/NDW294Dd2vD/TM8tDniDpQkVq8RmLbDqQbvVIC0YReBjqcElYo8CIcmHclIF9
	 3CTOfzDjftDFBaaVqQDPrGIB3nab59yRz5TdKjxIVHYHSOv9vJ+XCzR71MMPZ3GZ1a0Rj
	 3pRSa/QWHDVIcQ23KTnBVUkKA1xUuTvwEwxWmsBWzitv6ZqnPmGZhBG2eZvEiYv/ldAMz
	 w9MNRAxrDWk8kXMr5ksPf9lJWgK4av5TGgDoln1GSRtS2B3I6d8RRYFfQiXdeRoDr8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G0VEavm1;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB33606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 08:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCB33606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G0VEavm1
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1e34ecb02so3444225e9.2
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 01:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792742513; x=1793347313; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h/NfMB+35she+i0TxY4peuXbshaf1B5IwLQii+ni3vw=;
        b=G0VEavm1EDcGXTzHQCgLOT+Y5TwE8b2BPAovtnnkBRQZGXrnwd6CETd/Hy/ak8IJRr
         Vy1466LGig2+xyMy1eZRbkYhlD4JYUhD2e/Vv1NetsTa64z5kXltNxqolcX/mjcbGmca
         7Mf1azXCTUHq4iKbki7sIFqhus1wcpKMkbHoO5P5ISitvjgWbYSkOlm50qTuGXRCioH4
         SOJy13cqaWMrIrMqXA+qN/40h2eVOG6Oc3GhIxBIZcZHqx8kO92aR2nc+GzUEpPFNpxj
         /pe73X8F6p+F+u4oGzzvOoM/eSP+PNRKBFSwmyfY2juOk+lTVRNwhOjYZmSp6vrgdoOt
         TawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792742513; x=1793347313;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/NfMB+35she+i0TxY4peuXbshaf1B5IwLQii+ni3vw=;
        b=cg10iqYVSi6ktX3MCDGz3JnYDbgRWjy7xvmnuGm7MAHCQnATQXc+aPOW9/THMv+gjT
         4vTl96wawuoMG28yJFFFilWACKDv0EWr7Z8fO2qRRCJa5nEBtGTshvvY84pjuF1pgfw7
         KqOFBSmRf2BNnFPZt3dsAg2SV49YLg4Qs+SWjiZ+EefIsUeP1m6jsDHBRfK/+Xj1ag8j
         IaOrZ4kYTW2TRTe1HFmfIvT9Agdij6YvHIlFZ+eNdLP0zgFeGOmgba/A8WCCqeVgjMiY
         zefe4Na4iVvyWt4cdfNpTPq3Xqyua4oCBrUkdHCcMKQ+LVqNF9m+YlG2ow59pO8wX+gv
         Nqgg==
X-Forwarded-Encrypted: i=1; AKwUvBxnWe3llsBGa00rTeJREFWscKPvYD765UzlMYFFD2GCH5HZdtJ2dMHeC5sa2J86JAuErnXfIkE=@lists.linux.dev
X-Gm-Message-State: AFq9FYIOgE0qM8qJpRQUHlDBzYhoWukrnkw26j3vepPI9hRO99hnp77y
	avLTmymUBfl3FTSshEJXJdcNXEKX0etStXmCaVBcVx3BhTpTIHVyupeWyjqf3z75nQ==
X-Gm-Gg: AYBFou1MK0VJ/ZrNr5TYcXUnYDMAy2eOuymGYhdep+8kgOSCQEa6Cb01Vc2/ssSLLIi
	S3WHpUyJ8+OabEtfhvvYb6oAPIpVnGbklcCpROl/V0rL1ST9glvYQIRJDGt6AKhI63cRQ7+KwQA
	s+XERFooJYHB89NY/jc0upbXQkwOU4PGXourOYbWc5SPuEdDIR4oXPZ7ZPAotjoAgVPxsjF0qXW
	NO+2x6C8PcNwKwkAS9mHJCWpJEujEUcdat9ni03htJAIulBNPCTt6IMK1UAVypV+Who4jIgXQLA
	F04ECFpZDoBA7uGUH+Upo2vNLszuJG/Qw4UBbjzoxL1DsLrrmF/2SdY82hGzJ63SMk3Tr8cQqk9
	IhmT4HOXhZi8QZJs7G3FXgmNcbzmRuSZ3Y4NtkvQXsZc0XkA0eVUV5x9PB92WGgjsSKtKf7Z5Qt
	IbHcCX2NgcWqPnf9EIM56BdanyDq6lYXCD9WTBNA/rCQ2BMH8pJe8AL0TXzhUWDZrMMVJkFldsm
	3LttYMH8CSuqksc+8nA61HDplQWsXIfoOlLANJMEtkvxq8noQ4M0k4Ar6MworlAaaVxqvdnXt/k
	stXmerJ/T59jR+hhO+v+pJ1n
X-Received: by 2002:a05:600c:4e8a:b0:49f:fe39:5bc8 with SMTP id 5b1f17b1804b1-4a211ee9b8amr23155815e9.12.1792742512330;
        Fri, 23 Oct 2026 01:01:52 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a21555f9e1sm10347795e9.4.2026.10.23.01.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 01:01:51 -0700 (PDT)
Date: Fri, 23 Oct 2026 09:01:42 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	tabba@google.com
Subject: Re: [PATCH v2 4/4] KVM: arm64: pkvm: Avoid trapping on
 HVC_RESET_VECTORS
Message-ID: <atsUZv8-9is_i5r-@google.com>
References: <20261022140048.2522787-1-vdonnefort@google.com>
 <20261022140048.2522787-5-vdonnefort@google.com>
 <20261022173806.3752938-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022173806.3752938-1-fuad.tabba@linux.dev>

On Thu, Oct 22, 2026 at 06:38:06PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Thu, 22 Oct 2026 15:00:48 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> > pKVM prevents the reset of the hypervisor vector and as a consequence,
> > kvm_hyp_initialized can never be reset. Add a fast-path for this case to
> > skip unnecessary HVCs on the CPU hotplug and PM path.
> 
> Could you drop this patch? It brings back a pKVM check in the host code,
> which Marc asked to avoid on v1 [1], to save one HVC that pKVM already
> rejects.
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/86jynbyshv.wl-maz@kernel.org/

Exactly why I kept this patch separated :) 

It is a single documented fast-path while the series removed 5. 

But I agree this is only for the CPU resume or going out of idle path so not
really a hot path.

-- 
Vincent
