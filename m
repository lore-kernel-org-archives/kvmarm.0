Return-Path: <SRS0=+BBk=EG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F95DC388F7
	for <kvmarm@archiver.kernel.org>; Sat, 31 Oct 2020 14:18:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67C2320578
	for <kvmarm@archiver.kernel.org>; Sat, 31 Oct 2020 14:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S45am4CT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67C2320578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1A484B5FB;
	Sat, 31 Oct 2020 10:18:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M+rOQc602TK2; Sat, 31 Oct 2020 10:18:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A702F4B625;
	Sat, 31 Oct 2020 10:18:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C102C4B626
 for <kvmarm@lists.cs.columbia.edu>; Sat, 31 Oct 2020 10:18:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tq2DtzROdqog for <kvmarm@lists.cs.columbia.edu>;
 Sat, 31 Oct 2020 10:18:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F137F4B5FB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 31 Oct 2020 10:18:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604153912;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wVFV81cd1v6iGykijBckMAZ9Xzun8oblrqo+Iet6tP8=;
 b=S45am4CTBHJ7TuXDnKF1l0AiHNNCE2TM6YF04o1/4T4zXHiK94Hoqfm64tc2VlfIpoeWBx
 rW2/4uhXhj3cgU9HQ+l2ItDdKAuCjG/JyZKSpwsLmIF9kKS8AJ5NBvt7dCgZ5rdd30belQ
 UFpeG3Y4V/nUHLIzAVdJYgrHGI9+56U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-EnJhcjxRNNOKmQfeh0hEPA-1; Sat, 31 Oct 2020 10:18:30 -0400
X-MC-Unique: EnJhcjxRNNOKmQfeh0hEPA-1
Received: by mail-wr1-f69.google.com with SMTP id e3so4060573wrn.19
 for <kvmarm@lists.cs.columbia.edu>; Sat, 31 Oct 2020 07:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wVFV81cd1v6iGykijBckMAZ9Xzun8oblrqo+Iet6tP8=;
 b=gm/TD6z0cb7/3jl9ws3aouILmMruVORmD6I/MTMF9LrbpiRavd8yPn2k4bkS/QCt/Y
 H+28S+HbnUgdAx3GSv46/e3xxBb3zkLM0BDAY3+g4P+PG0/uWpFOcF+B2UA+w3Crx1f6
 VcrCg05G4w3o6RqvTp+VGOrYSOdtA8Pl7PFvPQvXyyuFqTnTFfu1ORK3Q4tcnEKh9wgq
 s4hINDPJ+fADeFfF2sF+UBCfoRhcuWyfw9ADDXmYZscTF2HrDOiOo3ZSWxE7g2E6rSKp
 iFuj+JMCIvCZ91rVmi8xa2pyRDxHk7SlfRBNfKlf90LuXQ0Y2YcX97loWpMvl7s+oaEp
 PEig==
X-Gm-Message-State: AOAM5308j5QRqoTh9aJgOOq/DIW1uyWX2WhlFf7n5ttVQI0v2G+qwBz0
 cEVH+cxHM1i2OgxXdPOjpWIBbjSqr8Qny3URht1O6KOTRd7PvtujoXQFy+7fbEf46B2nOeLEvo9
 AxcjhoPuVQP/E51xSatQLFjwo
X-Received: by 2002:a1c:1946:: with SMTP id 67mr8243705wmz.15.1604153909266;
 Sat, 31 Oct 2020 07:18:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0EE0jt7WTb8ogT7i9IaTstUvQah9vR8hZzbXyVrTiP1+ltSFU9N6/GJeX7c4M0lMzyreB5g==
X-Received: by 2002:a1c:1946:: with SMTP id 67mr8243681wmz.15.1604153908974;
 Sat, 31 Oct 2020 07:18:28 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
 by smtp.gmail.com with ESMTPSA id l26sm8514277wmi.41.2020.10.31.07.18.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 31 Oct 2020 07:18:27 -0700 (PDT)
To: James Morse <james.morse@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvmarm@lists.cs.columbia.edu
References: <20200818011319.91777-1-gshan@redhat.com>
 <4dcaea7a-a4d1-9bf3-eb95-ea9d8826ad99@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/6] Support Asynchronous Page Fault
Message-ID: <ae863cb3-4faf-555d-c34d-04b97d3ef486@redhat.com>
Date: Sat, 31 Oct 2020 15:18:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <4dcaea7a-a4d1-9bf3-eb95-ea9d8826ad99@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, will@kernel.org, shan.gavin@gmail.com
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

On 23/10/20 18:54, James Morse wrote:
> SDEI gives you an NMI ... which you use to set a TIF flag. This can only work reliably for
> user-space. So much so that you have code in the hypervisor to only deliver the NMI ...
> when in user-space.
> The only reason you would need an NMI is to interrupt interrupts-masked code. Linux can't
> reschedule when this is the case.
> 
> I can only conclude, you really don't need an NMI here.

I don't think the issue is that you want an NMI.  It is just that the
synchronous interruption that we want is exactly the same as a SDEI, and
so is the notification reply from the guest to the host (e.g. accept the
async pagefault or process it synchronously).

Yes, it's more code, but at least in x86 world we tried hard not to
invent new paravirtualized mechanisms if we could avoid it, especially
in the host->guest direction, and it's almost always paid off.  This is
because in case we don't get things right, it's much much harder to fix
them on both the hypervisor and the guest side; by relying on existing
code that work on bare metal hardware, the guest side exists already and
you can develop against it.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
