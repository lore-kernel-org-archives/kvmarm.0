Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FECECE587
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 13:30:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3126321A4A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 13:30:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3126321A4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EE0A4A6D0;
	Tue,  1 Oct 2019 09:30:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B6rHphCA6BNO; Tue,  1 Oct 2019 09:30:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 836464A668;
	Tue,  1 Oct 2019 09:30:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86ECF4A668
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 09:30:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w9NLcB7s0Cxw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 09:30:36 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E1F84A5C5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 09:30:36 -0400 (EDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 8AA348830A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 13:30:35 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id n3so1438176wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Oct 2019 06:30:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=BuheqY/f1O8hT7ejzmcdMbupLoR6grwp9uDRC8131O8=;
 b=YTPJIUivw5uDyDQwym+PPqaTomhVrmuuF5xE6/UiNLkv84CvoX/6cCcTksiF9DWvF/
 uxEX/4qtEY7vkKVHrfUEjNzNe/C9Zx/LKXa5nDAulI8/Aic9GqHGZDoOXBNZZ7fapli0
 s8n18j3ArN2AoBC0FxqjDbdgGlJwcC82YqnToe/sFvXYKqLgFKqSOxh6b32KTUOhfKDZ
 o5H0/wUykD4RO8F6bTgUpIfF+EbYC5HIad6PcTgKaGY+xI8j5lQz+Wn0Uxd4hN2yXbtQ
 7GH4nPAALZtnFb48+FrqU6tEC+voV+6kBVO+uAZePtLahWUgumw+vdF5IXdj1N5xOGaL
 lbKw==
X-Gm-Message-State: APjAAAVkItU24jnCqmOU+pxPFqz2/bk9g/73o3Sw15U4v9F9NUuF1u8g
 r9D0gW0x1q6w84M7mSiuT7g9UlMAbWl0rTFqgZ7xg5/dSFXb/p1NzMTY/JW+goprZnRdLJ6+IgE
 9329SwpcqiT0A5nqZRFQE6+8s
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr17650032wrj.30.1569936634233; 
 Tue, 01 Oct 2019 06:30:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyLoU8SG3DZmYpn/Y9/DQvwMyh6yTzew4TWcr6TUqtstV6yqJctofHmHyf+BOjVolXCznTz8g==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr17649991wrj.30.1569936633924; 
 Tue, 01 Oct 2019 06:30:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:dd94:29a5:6c08:c3b5?
 ([2001:b07:6468:f312:dd94:29a5:6c08:c3b5])
 by smtp.gmail.com with ESMTPSA id u22sm21010957wru.72.2019.10.01.06.30.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 01 Oct 2019 06:30:33 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM/arm updates for 5.4-rc2
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20191001092038.17097-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <52252764-5dd5-38ff-bbde-9cf92abf6c05@redhat.com>
Date: Tue, 1 Oct 2019 15:30:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001092038.17097-1-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 01/10/19 11:20, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-1

Pulled, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
