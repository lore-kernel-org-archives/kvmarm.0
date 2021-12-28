Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720ABC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 10:33:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6EA249EFE;
	Tue, 28 Dec 2021 05:33:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gdL69+mQBPrG; Tue, 28 Dec 2021 05:33:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B643249E44;
	Tue, 28 Dec 2021 05:33:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4313949E44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 05:33:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1BjRyyY1+Y3C for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 05:33:39 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C39149E39
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 05:33:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640687618;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SBjG/a985p+cb1ubBD+U1scKESLYs9cmGWO1wAxCDW4=;
 b=bAGrSObd2XQAuIZq15Npb26mulg+d+HInGTFrxyYf/B/3UrwnR7AY0E6fGpTg6mFvsg0uQ
 ATg2Hr5AidMNPRql7QLA9Wbn5pfRKID6N5vqo8t++0QRrK+gqBJ5XEluCcxIYnVPCJ5XvO
 MtgxH04jQlHXwNMiuFpaR8o6XlQijZs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-hc8aH_XLMzyvcfJ77eX_EQ-1; Tue, 28 Dec 2021 05:33:37 -0500
X-MC-Unique: hc8aH_XLMzyvcfJ77eX_EQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 t1-20020a056402524100b003f8500f6e35so12894250edd.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 02:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SBjG/a985p+cb1ubBD+U1scKESLYs9cmGWO1wAxCDW4=;
 b=ZGxb0DT2hRuyJ8VHZrm8SZmpv95bNzX2NISrgiVr3VhK7ZOcS5W7txjYMMORayW/iD
 Z/exDMP5KUhIsM2DBMTdS7Ik77282xJY3zafAgS/xFs/66jrG6qe3Uw6xzo+jUPbDy7b
 M/KAgHEDdmkUVvwMJdkuYXAqJFR7nS8Qo8o45JQylsA9/AUNKPF8iIGTMATSnf4xxAEZ
 vzBxjMjYdkmBRKBpM49FiKjVK4o3d6YaCGdgohvi99VAAHehz9tJzBO5lKmvSqsKBQdF
 i6BzPXTQ2gXKoRJkegJeEfrbYrc4EcfaXS9pf4jn1urXIbwvpQEXX8VI0VZZulEiV+2+
 A7Zg==
X-Gm-Message-State: AOAM532rxGwzqe76Omup4Cj5B804p0a017Sr4BmLvZcQnYLPiWIyUCIY
 kmeohJVQkpDgxgqJ47FDBwV/CtoJpFjcHDcJ1JawZXWw6wpu9D0JPpMkp2DvIe9+G5P2Qya2TO+
 5tK278K6ZYF5gV+amgVZd0HGG
X-Received: by 2002:a17:906:c156:: with SMTP id
 dp22mr16409106ejc.283.1640687616131; 
 Tue, 28 Dec 2021 02:33:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznxJ1o6y4D1qii3IBo+ZD3Ob9gcmDwntvGzoTLH2907uqCM0H93UNmHTwMNt1bk7+BIpA6sg==
X-Received: by 2002:a17:906:c156:: with SMTP id
 dp22mr16409100ejc.283.1640687615997; 
 Tue, 28 Dec 2021 02:33:35 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id hu8sm5965559ejc.32.2021.12.28.02.33.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 02:33:35 -0800 (PST)
Date: Tue, 28 Dec 2021 11:33:33 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: selftests: arm64: Introduce a variable
 default IPA size
Message-ID: <20211228103333.xhyxf2nytaw7z4wy@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-3-maz@kernel.org>
 <20211228092622.ffw7xu2j5ow4njxo@gator.home>
 <87lf05yqcw.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87lf05yqcw.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Dec 28, 2021 at 10:29:35AM +0000, Marc Zyngier wrote:
> > > +		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
> > > +			if (guest_modes[i].supported && guest_modes[i].enabled)
> > > +				vm_mode_default = i;
> > 
> > Since we don't have a 'break' here, this picks the last supported size
> > (of the guest_modes list), not the first, as the comment implies it should
> > do.
> 
> This is checked in the for() loop condition, and the first matching
> mode will cause the loop to terminate. This is the same check that
> avoids scanning for a mode when VM_MODE_P40V48_4K is selected.
>

Ah, of course, sorry for the noise.

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
