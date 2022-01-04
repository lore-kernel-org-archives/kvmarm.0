Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57190C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 17:10:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E4149F39;
	Tue,  4 Jan 2022 12:10:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lDa0x6t3AtP2; Tue,  4 Jan 2022 12:10:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66D3F49F4B;
	Tue,  4 Jan 2022 12:10:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DAB749F39
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 12:10:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gRddqKFWtw5P for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 12:10:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A102349EFE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 12:10:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641316205;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PLTIaY5gg/CGkjyFI0nVD1Ynp1qrSv98dwVoxTGL/gk=;
 b=AJW0duqdvpbTpNkkJJBxxZay8mHvtWn+4v0iQjIkvZi9YAb6hK0/S6XFzVUI7df99hSsn8
 8277Of9jev/146U9Q4n5RnY1SNlZYnbVV0T2B5GvD22qVhdBPw5kfaMEu8pJ2sZ0aZLoBJ
 d1+KF6U9RBMMiAU2HKyjQKbzaDmZwgA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-polc7Ux0PTWPoVG_ovezpg-1; Tue, 04 Jan 2022 12:10:04 -0500
X-MC-Unique: polc7Ux0PTWPoVG_ovezpg-1
Received: by mail-ed1-f71.google.com with SMTP id
 t1-20020a056402524100b003f8500f6e35so25854209edd.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 09:10:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=PLTIaY5gg/CGkjyFI0nVD1Ynp1qrSv98dwVoxTGL/gk=;
 b=3Wn3Gm6CaXxmBdQb/dWst22pSxxH51gEX7L1f4JsK61ymyYe8dMoRfCNtj7JUG37tg
 OkUC1kCRPxXNJr/YQmlgt1+cNya0OMIxOqp4ULHTPiL3ER4oPEtc7Kil2FXpFM+j+u1b
 aNP5sq/rNAopcYHtyG1difwL0Zuf7ChgBCWq6FOj0IwKTg77KtW8LwRRVA3LFuYnUyxu
 pIiAE+qXZS6Wft+jAy9gukpOTzBaEoMf/+P8DmBTpuyZemDIgNN0JfRAa6NQ6w6wZy8F
 coUOcTj+7k6QtV/TOxu2wgI9JVW2Yb+bJJoPtLFKSu1u4a1d9+k2Md59yrh6NfxUyxvc
 84ww==
X-Gm-Message-State: AOAM530bYVZNOJIGQC0OwurdQ7ZxYVkke3ZjFoNzw6xYjbKN447ODb1a
 XdYWtX4t/8C8FH23bgzpSNHgksVcI9oUiQ7XkQZo5p8L6ERYPcoJdUE/+huWBFb6nrlui1sGefx
 TMNmZUPeMW9Gd93OtDJsQVBcT
X-Received: by 2002:a17:906:9f01:: with SMTP id
 fy1mr6911389ejc.475.1641316202903; 
 Tue, 04 Jan 2022 09:10:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzg4c8oC/snOnarWsLYe2OuhHx3dyq7Vui9X2KCh4F+Gwu3wSidctLFczPe7rbJzItTjhvIEQ==
X-Received: by 2002:a17:906:9f01:: with SMTP id
 fy1mr6911372ejc.475.1641316202670; 
 Tue, 04 Jan 2022 09:10:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id w17sm14932963edu.48.2022.01.04.09.07.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 04 Jan 2022 09:10:02 -0800 (PST)
Message-ID: <b8e273bf-ae2c-cc5c-0d20-33f3dd12053c@redhat.com>
Date: Tue, 4 Jan 2022 18:07:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
To: Mark Rutland <mark.rutland@arm.com>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <YdR4N9QVYOzjowAb@FVFF77S0Q05N>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YdR4N9QVYOzjowAb@FVFF77S0Q05N>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, Anup Patel <Anup.Patel@wdc.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 rcu <rcu@vger.kernel.org>, Nicolas Saenz Julienne <nsaenzju@redhat.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 1/4/22 17:39, Mark Rutland wrote:
> My main issue here was just that it's really difficult to see how the
> entry/exit logic is balanced, and I reckon we can solve that by splitting
> guest_{enter,exit}_irqoff() into helper functions to handle the vtime
> accounting separately from the context tracking, so that arch code can do
> something like:
> 
>    guest_timing_enter_irqoff();
>    
>    guest_eqs_enter_irqoff();
>    < actually run vCPU here >
>    guest_eqs_exit_irqoff();
>    
>    < handle pending IRQs here >
>    
>    guest_timing_exit_irqoff();
> 
> ... which I hope should work for RISC-V too.
> 
> I've had a go, and I've pushed out a WIP to:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/kvm/rcu

Yes, you have a point and it makes sense for x86 too.  You can send me a 
topic branch once you get all the acks.  Thanks!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
