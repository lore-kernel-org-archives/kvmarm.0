Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC81CC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 15:30:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 543CA24125
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 15:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIdprWPC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 543CA24125
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA73F4AEC4;
	Tue, 21 Jan 2020 10:30:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fg52Rz12EZa0; Tue, 21 Jan 2020 10:29:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13CFF4AFC0;
	Tue, 21 Jan 2020 10:29:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3171C4AF88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 10:29:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pWQbzJKgbanZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 10:29:52 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 632E34AFC3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 10:29:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579620592;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=drluyyJgvZU1MSvZk9nVX/INIds5bPQT7NFflzdSLzQ=;
 b=DIdprWPCd3icdkJvpKZGSsrLU6TXoiJj5s2bntffE6pRcf3hTRdZTzDmJfxMyiqNC+xcI4
 ckRW6Pixk1/t+IHpe0dxGlHgUok6XuFg7C5dlHtfO7BBvZpbMiMPkzGe7EgO+fvFwQx8Wi
 ZjWcWtmw7ht9ztq+ectisIlB4/08PIU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-8shXb-kcOT2i71EFNY0-Jw-1; Tue, 21 Jan 2020 10:29:50 -0500
Received: by mail-wm1-f70.google.com with SMTP id q26so487591wmq.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=drluyyJgvZU1MSvZk9nVX/INIds5bPQT7NFflzdSLzQ=;
 b=Cv+4mxnY0+Lt51Gd6N9uN5fVc7G+iybZTTiEcRhOX4weiABAzobR4JSaqDEwm3zTuA
 VAalRORfHKtFHcQ9B24DjztcPpVWpgVI4xyarHAtuPzWXTQHofX2QSEkwqAYviGXfPco
 fdzBqReBDcOIPKvacbRPp+4/NG2ceqlcPLqP9Dj+Py6Bvq3FqnsRwvmDhrU5WNATglHE
 2uT92Fr69hfLVce14ZL0LcMhoWW/Qzswybqepkr0ViK66rW2pbplrHn0Dd1R1U0DV8ly
 l9HzdQR7PJPgZokBZyo8rWnt9l2E3Ew+9AS6h42e3zgbr/6aW4J4pWRb8uqOSYl3MW4M
 fFxg==
X-Gm-Message-State: APjAAAUzmA2K5tncRkKQWKyrK8wUCXn9QJ9sQc888iyI8seieZUXRVRO
 w+ytwwzk0m/1B9g/+p8PBe1I0wvodfdUMjAdpXS9piYKZu3ZFOlft+mh1vVn5pVRngx9StBlOib
 g0icFeZxC9igWupeNKLNiuMOZ
X-Received: by 2002:a7b:cb0a:: with SMTP id u10mr4986299wmj.165.1579620588915; 
 Tue, 21 Jan 2020 07:29:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzv1AiZkeRHvYhkTqdyoDwaDda+xt9Gb+5IDcg8qw+ja8rw8ozohTnvztIc5tRcztih3xCz/Q==
X-Received: by 2002:a7b:cb0a:: with SMTP id u10mr4986279wmj.165.1579620588629; 
 Tue, 21 Jan 2020 07:29:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id p17sm52810460wrx.20.2020.01.21.07.29.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 07:29:48 -0800 (PST)
Subject: Re: [PULL kvm-unit-tests 0/3] arm/arm64: Add prefetch abort test
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200121131745.7199-1-drjones@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b3033da-f347-f393-b7b0-3482a52a9185@redhat.com>
Date: Tue, 21 Jan 2020 16:29:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121131745.7199-1-drjones@redhat.com>
Content-Language: en-US
X-MC-Unique: 8shXb-kcOT2i71EFNY0-Jw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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

On 21/01/20 14:17, Andrew Jones wrote:
>   https://github.com/rhdrjones/kvm-unit-tests arm/queue

Pulled, thanks.  It may take until tomorrow before I push because I'm
testing 100-odd x86 patches. :)

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
