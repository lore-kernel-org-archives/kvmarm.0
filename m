Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A423FC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 19:33:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1615349F41;
	Thu,  3 Nov 2022 15:33:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oDtKVO5+pjaV; Thu,  3 Nov 2022 15:33:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E71784B086;
	Thu,  3 Nov 2022 15:33:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CED164B086
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 15:33:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2MI8JzoTA-W for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 15:33:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DF74141A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 15:33:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667504007;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bHrHw67H9V40qrnDXssLTsxUZ9uLutx6BAx0o7ln+HQ=;
 b=KejkPwYt2au5GpvN1Qh0KA878HSbh5EnK/i74TDp2gOWCjZJLPDhLfKx90ZZwEMsOgSnBE
 XQEQeP4aEx8naeddq/VBgIKWKglmkNfC5gdYS5lvDXHlWJU/2Y4ff+iqU6qQ6afDzkqcoJ
 BX0ZUnB4Stg0LKswanX7sEEVaIvpdfk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-iM1t5NfQNB-O-cmAON4fUQ-1; Thu, 03 Nov 2022 15:33:26 -0400
X-MC-Unique: iM1t5NfQNB-O-cmAON4fUQ-1
Received: by mail-qk1-f199.google.com with SMTP id
 bm2-20020a05620a198200b006fa6eeee4a9so2782182qkb.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 12:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=bHrHw67H9V40qrnDXssLTsxUZ9uLutx6BAx0o7ln+HQ=;
 b=rnVEdQeiMYiUY3L0mSc0tGl1kBEuFfyOQMSrM4cB1rf35RUAA5ijQykVOW0UTT1Ys3
 sRffatGRUcDMsftc9Cl6M66Kg5SoF0k8taMO/IyWWqG4ICLv0DG3sz3KKuvgcrLWJ+oJ
 2GHS03EK4CvT+GHG6c4cxvPknSbftG0upuQ/xVXRk/EShC1yMjxjBeAt8t3uXhKJrjc2
 y6nrI9z8Fq8cH2WaTD1fUFdPK49pnTQxSKk+eTy1Y9nGjJLuXD7jxRXlvDkijP9pbhZB
 MaBqlndiZ3R/p13ZVz1EwFmbc26eLH6RLdBXhhLTPS7RJwzwszTeSNiuhLZ6MO77ZOsx
 iPiQ==
X-Gm-Message-State: ACrzQf1aBf1WZ+OYIj0SAEuBseLQW/Gh59L4WgBOjCnN1pRrkBsz0/F+
 ELbnxQPIw9utVjPh6VZGGIkqhtOMAVzxrXq07a3NRF+kwu1/vrIhwl9y3j5MrbMZZD9gqAgt0Vl
 AB0lxRxg7mSDr5YYly8oQd9Ps
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id
 9-20020ac84e89000000b0039cc025887amr26208765qtp.413.1667504005632; 
 Thu, 03 Nov 2022 12:33:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4R+CVRPC2arwivP79Qld/IvHiKE/cb49gnSORd3djcfXtq8j0yR40+W1k4QyB1f4cAEtdMdA==
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id
 9-20020ac84e89000000b0039cc025887amr26208742qtp.413.1667504005412; 
 Thu, 03 Nov 2022 12:33:25 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 h4-20020a05620a400400b006eea4b5abcesm1353401qko.89.2022.11.03.12.33.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 12:33:24 -0700 (PDT)
Date: Thu, 3 Nov 2022 15:33:23 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2QXg5BMl8lMufro@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221031003621.164306-5-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
> enabled. It's conflicting with that ring-based dirty page tracking always
> requires a running VCPU context.
> 
> Introduce a new flavor of dirty ring that requires the use of both VCPU
> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
> the VM to the target.
> 
> Use an additional capability to advertise this behavior. The newly added
> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
