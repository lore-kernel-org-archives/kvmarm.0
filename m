Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C7BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 10:28:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7DBFA60F6B
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 10:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7DBFA60F6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1FC14079A;
	Tue, 21 Sep 2021 06:28:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P7erxMMArtJL; Tue, 21 Sep 2021 06:28:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD6D4A524;
	Tue, 21 Sep 2021 06:28:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD43C4A49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 06:28:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q9Y6hZ3VINm8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 06:28:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C94DE4079A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 06:28:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632220084;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IP/Ry7TfXJSJbGlXKKX4dVEELbv/TH/7UBpdWIwImZ4=;
 b=Sbsnu0NQ3ds4MGZy/kjtpNL6kHXa+SfWdbSADacI3g1pvohN3KkGObNWIV6g5N4ruC6Yuh
 rUF3llK80LFmxYNOPVamCRMNaTBRTCyA7wb+L7N/9YWVIy6F8SIe48ht4M3iWiZcvYGr5l
 loKsDMFnHMtKOygzZGcADBAGpVhqs9Q=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-QnXvmupOOBGukcAhnPgFKQ-1; Tue, 21 Sep 2021 06:28:03 -0400
X-MC-Unique: QnXvmupOOBGukcAhnPgFKQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 h24-20020a50cdd8000000b003d8005fe2f8so14480536edj.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 03:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=IP/Ry7TfXJSJbGlXKKX4dVEELbv/TH/7UBpdWIwImZ4=;
 b=ShkW1447rNKUdAh124Xj9doWAgdOARujw15nUfGkfVxbfp3sL3x0pwJBfsKQi2zkp0
 wT0AkmCITfE7plD7YqC9/919cueEGULGkr6Iba3U/PBwmho3I+9mXRSebK2g+1qjG03x
 KjVOS+ueVvO3IlYpaTHTCpTKZZUnHy3wtUFl9Z0qzYp6cMjvdPh3sokcuU+j39ttSFjg
 fRFblD6F874htTIcawmeL1jwHYbp5dVdHryOLf6faBi8hQFt/FpY40rS/1yBfe7T/Qyx
 Cem3/IH+HsXQetTOEpXgMeAN0KF9XNev2cpQ5CsWy0WI+UJ4aH5+KpV9rK/0Y792fICv
 3qCA==
X-Gm-Message-State: AOAM532OxJRsA7JtIbFVXy+Rck+KFqu/V+Yf31B6d1yu62wZNPb7Yjg/
 q3D0LwyBMkK2E0LrdPd0OavEnVizA4XuigQJ31S+AW7wYGUzcwK714b2W9rFfyix2cEVZsFa8KU
 Ipwf7ks5X9qniqotrbUvIA37y
X-Received: by 2002:a17:907:6297:: with SMTP id
 nd23mr35080855ejc.62.1632220082161; 
 Tue, 21 Sep 2021 03:28:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuFdS6sov9Hv8z2jx8fmfjChNJQUUjz1uvyE2T/Z4LMO6ndC/MCpzRZPVBseaf2sJ84TpraA==
X-Received: by 2002:a17:907:6297:: with SMTP id
 nd23mr35080837ejc.62.1632220082004; 
 Tue, 21 Sep 2021 03:28:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id c21sm7168400ejz.69.2021.09.21.03.27.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 03:28:01 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
To: David Stevens <stevensd@chromium.org>, Marc Zyngier <maz@kernel.org>
References: <20210825025009.2081060-1-stevensd@google.com>
 <CAD=HUj6_CFE0ZjexVMQMansmVcFRm3-udG=_12ROKfWDroNt-g@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c9cf3aa-7edc-4f02-b7cd-4c3d4950beae@redhat.com>
Date: Tue, 21 Sep 2021 12:27:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAD=HUj6_CFE0ZjexVMQMansmVcFRm3-udG=_12ROKfWDroNt-g@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, open list <linux-kernel@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 21/09/21 08:27, David Stevens wrote:
> Is there any feedback on these patches? CVE-2021-22543 was fixed by
> disallowing mapping of non-refcounted memory. These patches add proper
> support for mapping that type of memory.

Sorry, I was busy the past few weeks and I'm now back to KVM work.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
