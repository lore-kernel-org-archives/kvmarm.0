Return-Path: <SRS0=kePE=PC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65605C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:46:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C37D7610CC
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C37D7610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388854B126;
	Thu, 14 Oct 2021 05:46:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zwfw3TqO5s7V; Thu, 14 Oct 2021 05:46:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0C24B116;
	Thu, 14 Oct 2021 05:46:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E22FF4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8gbXQP1y+Y+x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Oct 2021 05:46:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 266694B0C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:46:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634204778;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PylHmPl0SG/ZoxPAA6fPJqlLgNo18jKHe8Um3g+bA5Y=;
 b=Jw+7hI0VfBJUApq+wgMA5l82brcHp+UQWS2IpZNI8WWw2nbB8SYOqRJqwmntipP7bioaRP
 aNpYUSS5S6GEGu/NEFhZTfcXh2Br2sAls1jcG9MTeJ+YmJPUQI8GHtrXWpvfXP4nf4ksUF
 TsYHGbMCjEvxpkFJN9bESZWJcY8Uw6A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-FoguKIbkPC2MOLqrm1WZ9Q-1; Thu, 14 Oct 2021 05:46:16 -0400
X-MC-Unique: FoguKIbkPC2MOLqrm1WZ9Q-1
Received: by mail-ed1-f72.google.com with SMTP id
 f4-20020a50e084000000b003db585bc274so4657381edl.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 02:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PylHmPl0SG/ZoxPAA6fPJqlLgNo18jKHe8Um3g+bA5Y=;
 b=3k5UizxwLSMGZ/de99omMtYotwXGwKTO+oYcwVhSZ7ScLH8j/RHgS7SnTw5LwbKfL3
 F+5Or9+dWWDLMRo1MlHpIWDy+rXflMY6NIEBkp9jWp6W4ka7rPGvFCOD0WiTj6x3GTw+
 ZjMbFnpmF7DDyOUMuZTIuOGA5OecXDj7afEgFIOlsW+/DJmSd8jqBWHaHVCd5XSzEeJg
 22zgQuwbV9SiHfMLZaW5bUAEMoQAeTFY3SNEWpiMJ+Eynf+cmf4uP9EjNNjGTkz+kc7P
 mTPu7LDO9ogGk4+BTMElxCRKWs8XDDC6UAz7GHsvG3bqxYtwGPvGOS/pHZUmj3E02YJa
 Im7w==
X-Gm-Message-State: AOAM530o3xyANeh7IMD2cRcAo1fD3J8tOMiN9byPs8UnkXLWkmQEhKNe
 GGgokG5cvXUJcVGngkyREiy18ZQ85b9uAl9MX24nfacjDk28Hfx2gaeVj1pD1jiKDVei8H98Pd/
 BcY1H4cmE0O2gvWvlgbv4GTUc
X-Received: by 2002:a17:906:3542:: with SMTP id
 s2mr2593135eja.379.1634204775415; 
 Thu, 14 Oct 2021 02:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOgCLWmlm5MOCVVA6YxDujZIjE3h0etTvc1U7zsLegPhP22dW9U+g1/6pZq5RjKKaGxfKpFA==
X-Received: by 2002:a17:906:3542:: with SMTP id
 s2mr2593114eja.379.1634204775260; 
 Thu, 14 Oct 2021 02:46:15 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id oz11sm1440208ejc.72.2021.10.14.02.46.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Oct 2021 02:46:14 -0700 (PDT)
Date: Thu, 14 Oct 2021 11:46:13 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 17/22] KVM: arm64: pkvm: Handle GICv3 traps as required
Message-ID: <20211014094613.tnx4xwyqrxj4jmnq@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-7-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211013120346.2926621-7-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Oct 13, 2021 at 01:03:41PM +0100, Marc Zyngier wrote:
> Forward accesses to the ICV_*SGI*_EL1 registers to EL1, and
> emulate ICV_SRE_EL1 by returning a fixed value.
> 
> This should be enough to support GICv3 in a protected guest.

Out of curiosity, has the RVIC work / plans been dropped?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
