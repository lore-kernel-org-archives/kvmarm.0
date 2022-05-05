Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6535C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 13:32:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EB1B4B1CB;
	Thu,  5 May 2022 09:32:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tyg3t7Ffecza; Thu,  5 May 2022 09:32:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DC684B24D;
	Thu,  5 May 2022 09:32:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED20E4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 09:32:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O5C0ms9pBJVs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 09:32:27 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [170.10.133.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 134504B128
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 09:32:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651757546;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+kiADHH0OTUEekRfTTqboMY0mUFLqzmSHiGBuu3QXQA=;
 b=UTMoBhW4SoONg1+zanmHNFXftfBWlFuobTeaCDOz/J1CgZJR2zF9qJaN5cLiGxwnojQ09P
 XJCUMKnZdNWW8JuXQZU5P1R6o/GKodqunViH10vBltMaQCShVIWjlv+huAXO/OsE6yVxqw
 PWjwak1p/BB4gtaqWRM+pTLoxFIQ3ME=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-OxszxYnZPMC7XIPK7oSxiA-1; Thu, 05 May 2022 09:32:25 -0400
X-MC-Unique: OxszxYnZPMC7XIPK7oSxiA-1
Received: by mail-ed1-f70.google.com with SMTP id
 z20-20020a50f154000000b0042815e3008cso2278157edl.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 06:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=+kiADHH0OTUEekRfTTqboMY0mUFLqzmSHiGBuu3QXQA=;
 b=VotqpiZhSEfWpm422xkxthf28MAWAfjQjdAONxba+XDdLmIEuh0hLbggQ7ToY8fhoc
 X/jUX2GevCGfujvmCc2wcSffAG5V+158LtgjaLahhOMdB6KeC/yjEZeKTNDhckkicUCq
 XHl7tiTXa/rX3sdIAyGYTbdfpo5QIFRZFl8t0OmrgQ0CgNGLZleQb0pnm4cNdjHFAdgc
 vmEzO+I78Of7rMg2M+/hC/IYW3rxjCbL4ySZKroswFcpSa58EtKbmQf8LVKKGkxGBjBd
 Qy6USALjs44XPMLn6rPFr0hlVMsZJNIJUqct6HeKznqUNJCP2W8f3x8G92Mcw1IQpA8d
 rxrA==
X-Gm-Message-State: AOAM532SOGWkyMuLGD5hmAy3ZmLa9CGIcQDzNQkUPKKegtmluU/zV8dk
 wVecpt8ge3zSlSSrbDKwsi5j3quw8qUsvZ9/lgPbjfTncELZmhck6rtwQpNOA4tLs+Mhly4dVQl
 ne5p2Sz6NSU5B2QQrx15RK447
X-Received: by 2002:a17:907:9053:b0:6f3:9f7e:5325 with SMTP id
 az19-20020a170907905300b006f39f7e5325mr26645008ejc.455.1651757544395; 
 Thu, 05 May 2022 06:32:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy52UhctkwW9yt5QGwSz6n+bp/2FcbovNN8FC8hnhQ4d8qEEUMnISxAnpY/IrKzXNsv5I+1WQ==
X-Received: by 2002:a17:907:9053:b0:6f3:9f7e:5325 with SMTP id
 az19-20020a170907905300b006f39f7e5325mr26644966ejc.455.1651757544125; 
 Thu, 05 May 2022 06:32:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id
 bc20-20020a056402205400b0042617ba63cesm812545edb.88.2022.05.05.06.32.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 05 May 2022 06:32:23 -0700 (PDT)
Message-ID: <688a817f-b2e2-4620-ef4b-f3c5f73ae34d@redhat.com>
Date: Thu, 5 May 2022 15:32:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] selftests: KVM: aarch64: Let hypercalls use UAPI
 *_BIT_COUNT
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
References: <20220504184415.1905224-1-rananta@google.com>
 <YnLa8uH55/epyjlS@google.com> <87zgjw6v9k.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87zgjw6v9k.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 5/5/22 14:04, Marc Zyngier wrote:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index e523bb6eac67..3cde9f958eee 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -342,6 +342,10 @@ struct kvm_arm_copy_mte_tags {
>   
>   enum {
>   	KVM_REG_ARM_STD_BIT_TRNG_V1_0	= 0,
> +	/*
> +	 * KVM_REG_ARM_STD_BMAP_BIT_COUNT will vary as new services
> +	 * are added, and is explicitely not part of the ABI.
> +	 */
>   	KVM_REG_ARM_STD_BMAP_BIT_COUNT,
>   };

That seems like a bad idea.  Perhaps you can wrap it in #ifdef 
__KERNEL_OR_SELFTESTS__?  I can't find any prior art.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
