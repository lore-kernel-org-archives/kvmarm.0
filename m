Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CA3C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 19:39:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A843B4B205;
	Thu,  2 Jun 2022 15:39:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7bxxhZrX4DRd; Thu,  2 Jun 2022 15:39:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3509C4B1DB;
	Thu,  2 Jun 2022 15:39:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29BBA4B1BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 15:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vQewCQTAHgg3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 15:39:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AAFE4B1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 15:39:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654198773;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=P7DY6xYYaortLAkVD1OrkZ8mE7+5GrGuaQeLtKFchRk=;
 b=OBbfT40NHUMDkC3nQ8FKuMmo59GZtEl4SHkeHEWf2qRYBEfKPLLHdErZXdZnNs8Pj+ZsQ2
 S4VTMIanW1QzmxtrNs0NEzrgcOQfDVhuYedhu2LfW2Ee42OQWICLnqGXSZ5exuexLa62wH
 wmtQFY0Xv+SiqxDlEbt/f6JYAuoznT0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-4eTC2C18PVe0QET0WzKN3A-1; Thu, 02 Jun 2022 15:39:30 -0400
X-MC-Unique: 4eTC2C18PVe0QET0WzKN3A-1
Received: by mail-wm1-f72.google.com with SMTP id
 m26-20020a05600c3b1a00b00397220d6329so3288446wms.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2022 12:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=P7DY6xYYaortLAkVD1OrkZ8mE7+5GrGuaQeLtKFchRk=;
 b=12tslAU4YEar+9L/mkQYgnhrm8cxaU8v0yT5Hdzf9Y69qkRL3sgsNfb3t90YRIdG6n
 zLvAf+Wgz6/uTWj4Bz0emMKmvjR3V0sS9sZhGpcNJykrwWtOkaXW/lDOZbrP6CJHG0SU
 WNuvMqOOOIls/2tDc4tKK30pIuzSlm7dg9Se5Izk4SKl+d4dWqYARZKoL227fiFaUAtD
 NGoAN/9+ITcPRH025XnamEvxLbIwN4kFj6+OvGWR9JZCuHuWIboUTD+J5Oc0vwx1EfYE
 OfE03ehNwHegYywFiQmp5OKPJelqRT8e0mGDe1iVBknmGuAJsX2t6OW2K8Sh48sIaqx4
 KY2g==
X-Gm-Message-State: AOAM531A8lcadMnKFRREQyAeTjfVN9e13Yy5B0iRWMaOHv54DqqWEwaj
 XITkkGV7Wl+7AwPYH2oFmY0jJv0e/g8yH2lOg8YIJ9VTPGv+UHPFzx6T/Pc9aAcQiWLlU2AMtPN
 +dblxIHAnmw92u3df73pRTVWn
X-Received: by 2002:a1c:f710:0:b0:394:1960:e8a1 with SMTP id
 v16-20020a1cf710000000b003941960e8a1mr5369357wmh.154.1654198769470; 
 Thu, 02 Jun 2022 12:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb5NUdRMKDEDqs3OehCuJ3A72dORJRZuj3TUcjk/IR3G+DoIyfVTVdoXGCVMUP1AOlTOWvvg==
X-Received: by 2002:a1c:f710:0:b0:394:1960:e8a1 with SMTP id
 v16-20020a1cf710000000b003941960e8a1mr5369332wmh.154.1654198769164; 
 Thu, 02 Jun 2022 12:39:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 h9-20020a5d4309000000b002102af52a2csm6442171wrq.9.2022.06.02.12.39.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Jun 2022 12:39:28 -0700 (PDT)
Message-ID: <b0c08d90-1bf0-6996-379e-61f0d5724fc0@redhat.com>
Date: Thu, 2 Jun 2022 21:39:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/3] KVM: arm64: Warn if accessing timer pending state
 outside of vcpu context
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20220602083025.1110433-1-maz@kernel.org>
 <20220602083025.1110433-4-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20220602083025.1110433-4-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com
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

Hi Marc,

On 6/2/22 10:30, Marc Zyngier wrote:
> A recurrent bug in the KVM/arm64 code base consists in trying to
> access the timer pending state outside of the vcpu context, which
> makes zero sense (the pending state only exists when the vcpu
> is loaded).
> 
> In order to avoid more embarassing crashes and catch the offenders
> red-handed, add a warning to kvm_arch_timer_get_input_level() and
> return the state as non-pending. This avoids taking the system down,
> and still helps tracking down silly bugs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/arch_timer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 5290ca5db663..bb24a76b4224 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1230,6 +1230,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
>  	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  	struct arch_timer_context *timer;
>  
> +	if (WARN(!vcpu, "No vcpu context!\n"))
> +		return false;
> +
>  	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
>  		timer = vcpu_vtimer(vcpu);
>  	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
