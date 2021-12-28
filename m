Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326D9C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 15:49:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F8240712;
	Tue, 28 Dec 2021 10:49:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4dqau9aYEyAo; Tue, 28 Dec 2021 10:49:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A86640D74;
	Tue, 28 Dec 2021 10:49:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D95840712
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 10:49:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5FQfuDTvLEHQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 10:49:20 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18FA7400D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 10:49:20 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640706559;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ycaX1I6cQki2ElBFoIZec501uCWjSCGIAPC5v/9/3KM=;
 b=PofkWOqSgs5DfVM7YcE1g8xysggMfrAB1t6a3mZNJZ1Pv4B7oQQzt7kLK+AkzKLtS4Vdm8
 HlbLzeTuxNvzsxEsfCQpzX+lWMSxP4zr8k0nUTqXoPvC2yWVUDX7YW3MMRVngCG2eGhDLY
 atb0efDKXht6XH/e1aoVmQz4mm3spcQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-t3wIj-S2NE6w4V_BiueF1w-1; Tue, 28 Dec 2021 10:49:17 -0500
X-MC-Unique: t3wIj-S2NE6w4V_BiueF1w-1
Received: by mail-ed1-f72.google.com with SMTP id
 b8-20020a056402350800b003f8f42a883dso6142152edd.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 07:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ycaX1I6cQki2ElBFoIZec501uCWjSCGIAPC5v/9/3KM=;
 b=FRt9owgsiRrbH0XsLvEHoOaAju56toFAzzb5ZQLP8ZmJvHzaXU9vz69gO5IwCgBI5M
 6D4BDS1KzonifnlpSRIBE6tHJWtwVZ4HPWteHnkBnZrJLvDBKIJzLHgIZ/csvehZeOEm
 x9DIa8sn+P1NDeVQaYsn4pu9FDVehlnaeI6REtuaGOnMjSXF0yzNGYt9ZB568+JD1Xh4
 xQ2yY51d2Zgeien2KlSzKpTueVO0VDrgevmaPgnxYItZ4x/ychNjMcHTMKx7JZCcNbJc
 UcYuINvaloRhToPHd4WNc6KmeWW0aL2dYA2ISDmsGm9MFhfI6vRseiJHjgnn7wpocY4X
 KZeA==
X-Gm-Message-State: AOAM533d6InFbbF8DiBqDSUX8RqpX5FUqnUKY3vJSM6cAxJ8WxPZAdpJ
 XebLEHzGO70ZcfLIT/cX1AcBd4+qefagy25gJNqUYI9ZlNFY2NM4Scze/7blu41AK5gBakViUaX
 x4ls/YAycg1Hd5gDv8X47oNN3
X-Received: by 2002:a17:907:6218:: with SMTP id
 ms24mr18128807ejc.520.1640706556805; 
 Tue, 28 Dec 2021 07:49:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVRlq/tAOI51DmzhyS+1JIQQzYL0mPFufqb3TGKXiXLeqn5H3FF3YL0ZuyyqD7t5ua4Rx5Qw==
X-Received: by 2002:a17:907:6218:: with SMTP id
 ms24mr18128788ejc.520.1640706556555; 
 Tue, 28 Dec 2021 07:49:16 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id c7sm96339ejc.208.2021.12.28.07.49.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 07:49:16 -0800 (PST)
Date: Tue, 28 Dec 2021 16:49:09 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: selftests: get-reg-list: Add pauth
 configuration
Message-ID: <20211228154909.sig5ltzn6ziolfil@gator.home>
References: <20211228121414.1013250-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211228121414.1013250-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Dec 28, 2021 at 12:14:14PM +0000, Marc Zyngier wrote:
> The get-reg-list test ignores the Pointer Authentication features,
> which is a shame now that we have relatively common HW with this feature.
> 
> Define two new configurations (with and without PMU) that exercise the
> KVM capabilities.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 50 +++++++++++++++++++
>  1 file changed, 50 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
