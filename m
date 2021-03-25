Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7F4C433C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 18:13:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 966DA619C7
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 18:13:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 966DA619C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E7C44B22A;
	Thu, 25 Mar 2021 14:13:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UfcDFdEVLkCa; Thu, 25 Mar 2021 14:13:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14C094B238;
	Thu, 25 Mar 2021 14:13:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D954B237
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 14:13:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jMjVL9YA7znS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 14:13:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E86B4B144
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 14:13:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616696030;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uiCdIYAQx4Egk1IFrgMr9yPXh2tXd1+ed+O6pyW2k4A=;
 b=CBW398tKaM2bYGjH9HP/uw8gP+30O135BxOJeS2hKYq+2lvklZ6MWn38lh/k1kLe2TXOZV
 nOeAjHCR6idBSgsO4mtXtWOIsTeykoY1lTGRW9m5Y+1Ngig4C2EHMcTaxrX0xtUO4ihF8N
 Mj1pSG+VeevYbj0pA48/D/OrqQcH9I4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-mjU0eOiqP1GXM6jcM3HCBg-1; Thu, 25 Mar 2021 14:13:48 -0400
X-MC-Unique: mjU0eOiqP1GXM6jcM3HCBg-1
Received: by mail-wr1-f69.google.com with SMTP id e9so2423807wrg.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 11:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=uiCdIYAQx4Egk1IFrgMr9yPXh2tXd1+ed+O6pyW2k4A=;
 b=qTF/peWQ9ZFd092A2cXiAD1A4ZizYJY61T/UG9jESzKFrV8O/XTh56XgNHVIx4AAdf
 yGyn5QRWF7duuvtMxDwwrAx3GvIzeHcrL6+F3uWUJb9JK3bIyO/OtZBj3yFgr7CfiwLp
 Hwi9xTwQHVFceNwa736yTQfkXXlR6lPBnAttkZpohc9AIalKU/oQcSwcobHqAFwDcT+y
 IrVntfJ5d2+71hz1lxlvCCNFUmSuw12PdUlNXQ4TFlCghhQEcgHy6oLm3NCbwRU9r5t8
 ILrBg+iqqCulX3A8Z/46gWpWeR6ROCHPOqEHBh31cInxSS8OlW/B4vte41vkzbij0SzU
 GkjA==
X-Gm-Message-State: AOAM532VoOfUnbw+o6QwpKE7JqcTEcGgNOTMqlFDooeTc3m50potDEw6
 HZDvp3c+6trvdyszzOto4Wy8pZa/D4zPjeUMIPfARpLbPyonVNIiP09W12IeHvcv74aTNXL2cG9
 TDu2pxqCN5lWkxkwfehwxX0F6
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr9084944wmh.32.1616696025959; 
 Thu, 25 Mar 2021 11:13:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyc+5BOjBmvH8N6msX4fL6crdronTklD4godiHBJIh10cFpPrRmQsfRyBQj+r2xEcYFcPe7w==
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr9084918wmh.32.1616696025710; 
 Thu, 25 Mar 2021 11:13:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id o2sm7325281wmc.23.2021.03.25.11.13.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Mar 2021 11:13:45 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.12, take #3
To: Marc Zyngier <maz@kernel.org>
References: <20210325114430.940449-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09d76225-c9ec-46a9-0ba7-5e22d1669c6b@redhat.com>
Date: Thu, 25 Mar 2021 19:13:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210325114430.940449-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 25/03/21 12:44, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-3

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
