Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D789C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:47:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E806A4B1CC;
	Tue, 11 Jan 2022 04:47:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bVJ2pP9uUJb0; Tue, 11 Jan 2022 04:47:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99FE14B174;
	Tue, 11 Jan 2022 04:47:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D394B174
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:47:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u2YOSh5LQHZd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 04:47:32 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A449C4B172
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:47:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641894452;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GrmA+PXG2k8gd1CgfrfPZfbAbd5si0dF+8rL+GfOaoI=;
 b=gfpYrmVoVsEJy9oz0gvnOEjlQBFJAtZcmA91ba61Jg6HT70Km8rQhxm8BwMjT10aJfFH1z
 SE7sZeY1duE8tjuKimr20ez4WvQRNRbXz2d0zLdX+O8EwmLfMfyEEn7Dlv/85lSHXbcJFv
 QbeXGQuZtMo6hW0KFsrigcXK5Y2zNRQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-soDaN5ZjP9mAmWNAkHW-7A-1; Tue, 11 Jan 2022 04:47:25 -0500
X-MC-Unique: soDaN5ZjP9mAmWNAkHW-7A-1
Received: by mail-wm1-f71.google.com with SMTP id
 m19-20020a05600c4f5300b00345cb6e8dd4so2939057wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 01:47:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GrmA+PXG2k8gd1CgfrfPZfbAbd5si0dF+8rL+GfOaoI=;
 b=FuiYO+2gkwl9CkH5Ipbkhg/xUGKXxfXMuF6XtqZQYO3WegLuZxfHjuHSorL+XtJPbD
 6yuKiRY4nbTQT9GW3PhNA7ZDmKI8nxmF0CXpi21tyA0inwvApiM4EGkIcIzskEXS2dt9
 Yf9YqZXbS1Kw4xWricAOrPRsTCOeAGmjYRSQfmKr8nD6n8qqzE1LSMk6CAgEafXsD4CQ
 1oPFrT5hUy9TI/1uG+PVE+uCr8Cm+KH3YRPoanlPNizRwOAO2MHrCkC7IR14VV4utJ2l
 XwFDYyd9iM6iaUPvGboSF5mDgiLZnIEQhqZynj52D59oyUU3+44Pcc/jbexGaE2tItH3
 mQVg==
X-Gm-Message-State: AOAM5334yCxuxuHBuovn5UB2gAKKMW++mJ7oALML9YvPw4L0cBBpbvgk
 FUBnuRcfdN2INFNkohIq0erVMoFkssTZqv+n0ELp9oLKyL6pzVZUtQfJcfuiqIkhpyJEUb3y936
 2bgT8XWjF8g4TcGP2ZRIyj9zM
X-Received: by 2002:a5d:4701:: with SMTP id y1mr3072352wrq.287.1641894444534; 
 Tue, 11 Jan 2022 01:47:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzI/cKwPYMwt17iYUFub9wSmgF/47I4e6qGZvUhPa7yc9tJX/yXF+JQnBxGIzDhLRiFJ3ORlg==
X-Received: by 2002:a5d:4701:: with SMTP id y1mr3072339wrq.287.1641894444318; 
 Tue, 11 Jan 2022 01:47:24 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id u12sm8671751wrf.60.2022.01.11.01.47.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Jan 2022 01:47:23 -0800 (PST)
Date: Tue, 11 Jan 2022 10:47:22 +0100
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
Message-ID: <20220111094722.cvj2zjtsh64jjg4i@gator>
References: <20220110054042.1079932-1-reijiw@google.com>
 <20220110054042.1079932-2-reijiw@google.com>
MIME-Version: 1.0
In-Reply-To: <20220110054042.1079932-2-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Sun, Jan 09, 2022 at 09:40:42PM -0800, Reiji Watanabe wrote:
> Introduce a test for aarch64 that ensures non-mixed-width vCPUs
> (all 64bit vCPUs or all 32bit vcPUs) can be configured, and
> mixed-width vCPUs cannot be configured.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
