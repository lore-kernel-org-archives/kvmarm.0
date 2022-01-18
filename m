Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8795C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 16:20:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184FD49EF2;
	Tue, 18 Jan 2022 11:20:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nxRRKxakx0vJ; Tue, 18 Jan 2022 11:20:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9377C49ED2;
	Tue, 18 Jan 2022 11:20:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F72B49EDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 11:20:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rK6Tb9n7y7KQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 11:20:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C74D49ECF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 11:20:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642522847;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EwrulS3gzA/74heRhQ+jQxvPAPi0xIckrPJaoqht2/c=;
 b=GLliu860+WAe3w6Uoh7c2gXva5qRAcQFaGWlPyK7YoNhHQmYPt3xC2VbMcn6O8tHZYt+gA
 cd7SWjBgl2XWoIr/+qFbLYI1WezEFI66AA2tyc4zpideafkFnpU1XnfAwRDyB5VNzzszqu
 q0WJWbFE5i75vI3o+KyjpEmtXjQYzyM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-XarwODMeOAypPJaLA7mB-g-1; Tue, 18 Jan 2022 11:20:46 -0500
X-MC-Unique: XarwODMeOAypPJaLA7mB-g-1
Received: by mail-wm1-f69.google.com with SMTP id
 c188-20020a1c35c5000000b00346a2160ea8so7279488wma.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=EwrulS3gzA/74heRhQ+jQxvPAPi0xIckrPJaoqht2/c=;
 b=n4vfa5eVVJCFmdaoGfoiv5n3xcCPir5Ll0iH4kRvqNvdEKdTRaSGaz8Pu7ZyYQvyhp
 DStQWFBqwgEzv44SCuKt0WXxSwcpfl79rwPdaTFchhlOhysp5Nv+AAMHB2GEdOLQij7O
 8BFlNBsfYj6hriwm/Sjr+hodU10qeZwjulgoTWKLA+726iVKn136Uo7EV6WfPVx9k6n2
 jy1WQDPyOOLpxhWf5We7WPp/8ko6gKpiKN/1VU8hDCL5X46s1S2oofoitASBo1oGuRFF
 fGXqpKUMIgCqT3v37GKng/EERHc+30oeHUvlmywAQ7GXoAjwtisqPz0p5ptSOoU4UvVt
 9rKw==
X-Gm-Message-State: AOAM531Omo6wQ4I8PrKnYUIs32MFcyg3o68OczqsQ7J6Loj62AJEeNMW
 GEjSBHJMpn0CUIqspN6/29NUu//yGUHapJAk4CAcvOMDco7zR3iy5b34mKPVnPB3Rm1atAb8a5N
 p4Wll5ewebuALVtAHHUZgxs81
X-Received: by 2002:a5d:4c4d:: with SMTP id n13mr25057000wrt.641.1642522840125; 
 Tue, 18 Jan 2022 08:20:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTz1c1QQcAMTiHafm/jmwdXgrf7wUWM5hGJvGgdN/CAmFDEzHQguURZEtsbIR0m3l3jikB/Q==
X-Received: by 2002:a5d:4c4d:: with SMTP id n13mr25056991wrt.641.1642522839929; 
 Tue, 18 Jan 2022 08:20:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id h2sm3124218wmq.2.2022.01.18.08.20.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Jan 2022 08:20:39 -0800 (PST)
Message-ID: <0c3b360a-8b95-0a18-a5df-59249247c291@redhat.com>
Date: Tue, 18 Jan 2022 17:20:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests] Permitted license for new library
To: Alexandru Elisei <alexandru.elisei@arm.com>, thuth@redhat.com,
 lvivier@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <YeboYFQQtuQH1+Rf@monolith.localdoman>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YeboYFQQtuQH1+Rf@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 1/18/22 17:18, Alexandru Elisei wrote:
> Hello,
> 
> I would like to know what licenses are permitted when adding a new library
> to kvm-unit-tests (similar to libfdt). Is it enough if the library is
> licensed under one of the GPLv2 compatible licenses [1] or are certain
> licenses from that list not accepted for kvm-unit-tests?
> 
> [1] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses

Any GPLv2-compatible license is acceptable.  GPLv2+ compatibility is 
nice but not required.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
