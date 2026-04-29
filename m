Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB0D3FF8BF
	for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479251; cv=none; b=EeM2WKgD7kES4iuf8SfDxWnx41R3NVgb4R1Gs/TYG/MBLSYJzDP7CKN61tqSvZGFZn4pM+JJnSUl119H69aKmSr3UUwMbd3b0JN6llW4E/QjMPHb/IdOKWxMtHO88pSq60AE0sPzX9hB1l11tSvOGWjm7TzYfEi8tk4+cwvijyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479251; c=relaxed/simple;
	bh=QIUvdq75lFARum0k0kDOdaUv3IFA90teUppVmMvzJ/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulcrFsCQVJ4wMTzG7H0qb/Ik8pcIaulHTGkwLR2M2TsjsgDwBO6ORNVc/iHjxdemAwKdvuGMEPjcyilDG8XcybQR4cQBGH0RS+NvAiOTq4Mt8foo3KCe+l3+NfftOQX5Nu5fRb8jqcY4pMFYKwo22z668TXuLt32NIfNTT0uyfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=JFxcEJnj; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="JFxcEJnj"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ed4dd182efso678699285a.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 09:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777479238; x=1778084038; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JQwXlv6d4SrpAwunOCAy3T3SkF7dwQSFYcS5dAIRLRw=;
        b=JFxcEJnjXgILTSLgLP6I63PR4JZwMgVS+q388jBybEJOG9MmACXQHKXmoXFUyg7tSn
         ScBWurXJw0XwhWxxK5CnwBE0o7J6p2vyF3s1YUrLkOQIAGPJQ3iMJZDVP84uYBlzK/Qv
         Ik4nofKEBOWGRSrdIelv92SBUWmj3VDJHDKtf5TZBR6pFdJhM/2ZDdlLfD4DDCBPC28q
         OaZEhixkd9utbBOVi9G2XfeZDIoG11/deI0QnqY/+By+7WrT05dTeIQeIFJ7MXFO2QGE
         MQDSPgIFaB8pEK1jO39C3SPih7O7B9b4yHO8WAMjsUoPdm7XC0jUEjyUWWlL+SH6orx7
         OWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777479238; x=1778084038;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQwXlv6d4SrpAwunOCAy3T3SkF7dwQSFYcS5dAIRLRw=;
        b=YU3FKOlSu2rz4y3KOCt65fNTcSc/4sY1RAoqvxYBag9WgxD/THIRwlwsFT0heJn3kN
         +RYPLbgRTsNnjvSNeHuUpFkkA5KUQMrG/amhZbMsC1vv5rdglynCLLCLLC9z+8hRpxQF
         e7AiL3F+HgmhFMOcnhCEbNF88c44iVPtSoG6fjvyFiPVMI6+er6R/sHoafoCLuRfKkPz
         ufxu3UI7COfyTeHgU6wK83EiOCgltDpmWm1J7vQ9yO+N9835FyYsl1CV0S9wH7nwNpRu
         3BK8e8k1fq9bQg0eT+NLqznmcRU9+D5vqd0MFhywsmno4D/d/h7WcqFXobg/logLy1hT
         Qq3A==
X-Forwarded-Encrypted: i=1; AFNElJ/mAzRU3gEa8PSpKFvzHpuvMR574OZrWm2ZDbGgB+UIjPrCwMaZrRb51MXaSxeSg+PeMDY7cio=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvSk5l95vcmzv72f0wL5Y8pGZh1Ooekoc7lCrWJrz2A6eXYyvf
	LlAVeavCs/3FlLfQ2QMs55ubeuT7z6W/wik/Mq4CWOs64hTJcmSpIWEhGB7mtbVptFs=
X-Gm-Gg: AeBDiespODE9DZyKcOHX0y3VAEtgBGq24t3NTn5eUlS3buCnGQA9W2aS+/qjqAVaOr8
	AycKVhzH+QOMCy/MvoIdHKhEXCM8nq6I+eAqK/QQyFZreUIBILqBcBOPNS4lsVwUmdyzJLjfcr6
	tmIhaRjtqVmwq232eLNRPj1OFURQ6h2MpUHJCI0LAQHdGFQg7Y8EZo4EPEPdxuw5lROlv7Ecrau
	6mg/Hh4bFqdsBfLrEDG/S/Lh47Jt0uPMyB5zQRDUH7DFVKlaKjWhK+a5LhJl/iTz0k38/2c4IA+
	ngJ8nDqk6DIDLc7wwpytBEnCcRf7YatiB1gs2umOj/EtKedcXIEoxeJTMXR1Il0aSM0I25XOQSb
	yzYdkiaENChrvDHbQK1imYI1sPPkMrMycqzPIdHgVK/cvpnx12mkL7NVYcQreIVqxdaFadCSjsp
	aCSJl8goI7ljZyeUpqY8VIQQ0feaaiNjNiNuAJSrEjaH2QRD2p71tHqYjSvPNm7tidIIRAtHVg
X-Received: by 2002:a05:620a:472b:b0:8cd:9033:172a with SMTP id af79cd13be357-8f8f3a204a5mr643580085a.3.1777479238360;
        Wed, 29 Apr 2026 09:13:58 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f93f5826f7sm235640585a.30.2026.04.29.09.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 09:13:57 -0700 (PDT)
Date: Wed, 29 Apr 2026 16:13:55 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, rppt@kernel.org, 
	pratyush@kernel.org, pbonzini@redhat.com, seanjc@google.com, maz@kernel.org, 
	oupton@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com, 
	rientjes@google.com, Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, 
	baolu.lu@linux.intel.com, david@kernel.org, dmatlack@google.com, mheyne@amazon.de, 
	jgowans@amazon.com, jgg@nvidia.com, pankaj.gupta.linux@gmail.com, 
	kpraveen.lkml@gmail.com, vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, pjt@google.com, "Petrongonas, Evangelos" <epetron@amazon.de>, 
	kpsingh@kernel.org, jackmanb@google.com
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
Message-ID: <afIru_PE3W0hIsu7@plex>
References: <afEwWZksU0Fw61oT@plex>
 <b52e7d0a-4275-48a0-850f-6ceccfd5204e@amazon.com>
 <cd0ae5795cf14a7b20c90840b0a3eba7db160e72.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd0ae5795cf14a7b20c90840b0a3eba7db160e72.camel@infradead.org>

On 04-29 09:40, David Woodhouse wrote:
> On Wed, 2026-04-29 at 10:13 +0200, Alexander Graf wrote:
> > I would prefer we only attach the whole caretaker and all of its 
> > specialties right around the point when live update happens. Why keep it 
> > dangling and active forever? That way you can also late load the kernel 
> > module that contains it, so you can be sure it's an up to date version.
> 
> "Why keep it dangling and active forever?"
> 
> I've always wanted to tie this to address space isolation.
> 
> The only way to truly stay in front of the constant stream of new
> speculation vulnerabilities has been to just make sure there's nothing
> sensitive accessible in the address space at all. Hence all the work on
> secret hiding, XPFO, proclocal, etc. — and hence the occasional
> researcher finding their shiny new (5-year-old) vulnerability and being
> confused when it doesn't leak anything *interesting* in certain
> environments.
> 
> I'd like to see the inner KVM_RUN loop switch to a completely separate
> address space, in which there's a kind of caretaker which can handle
> the bare minimum of interrupts and timers and the most common exits,
> and which *relatively* rarely has to come back into the real Linux
> address space.
> 
> And once you have that caretaker running in its own address space...
> why not just let it keep going while Linux does its kexec?

Yep, this captures one of the benefits of having a permanently attached
Caretaker.

By establishing that isolated execution environment for the inner
KVM_RUN loop to mitigate speculation vulnerabilities, we naturally get
the hardware-enforced boundary required to survive the kexec gap. The
Live Update capability is effectively a byproduct of achieving true
Address Space Isolation.

+CC KP and Brendan
