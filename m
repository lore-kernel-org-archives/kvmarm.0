Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5192C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:16:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61F6461029
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:16:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61F6461029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA99E4B190;
	Mon, 25 Oct 2021 10:16:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YjTBt96n0D8u; Mon, 25 Oct 2021 10:16:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E768B4B14C;
	Mon, 25 Oct 2021 10:16:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C08E4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:16:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xp1x6c1GECsa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:16:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AEEB4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:16:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635171395;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1yBIeDqOkiGFurlFgD43y7wdSJN5RQI+Z9N38wXwm0c=;
 b=SUo34g/0kM1CYWnu/LExwYWV1SKFIlW8y+oySv51K1nK3/PPXv+QOi2Lbpq1HE6z3xXF7t
 zSHjExMDr5ZYlgOkDFONxkC/k8IVGLgl/arAl8biSmuA0uqFTWZZhuqheJda/oYoqHOMtZ
 cp5pxbm3hj6Sz0I0HUShmxhosa5rtuk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-VZEmJgD9NZKLT_dTFhOTkA-1; Mon, 25 Oct 2021 10:16:34 -0400
X-MC-Unique: VZEmJgD9NZKLT_dTFhOTkA-1
Received: by mail-ed1-f71.google.com with SMTP id
 y3-20020a056402358300b003dd490c775cso802265edc.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1yBIeDqOkiGFurlFgD43y7wdSJN5RQI+Z9N38wXwm0c=;
 b=adCEJhaIXEVdPqJNgQ9eCsrBrorXgC/Qz1Q3j/A4Qde9eJSXJCcoWZnri9MqZiuYTz
 HAiho0V2g2Ne2z9q1JTXhqNd087pt/WxXs5kXUrXfylwo8qteEu5A4Hzk3IB1DzT8N1P
 zuoY5XuR65F95kg3JdoIYQrI5OXtKBPIyGx2cekb2gKOuqpIOo1rObM8cWq+XlJFeX4W
 JvXhiGmt61hmpjLhxGnoFhrKdKMhCrKPbG22ely/uMn1ujzKvFudkuMeLAFyx7Ol49og
 vNRaq/ZYjTpdleUjVyV/4L1qXu9tUn0ISHQ0PRKD9gOj+eZ2juwM2eVCOiCGIgwY54Of
 PJ8A==
X-Gm-Message-State: AOAM5331FDInXc0m8D1RHw+wg0aG+CRjqkhXjoIB+c8ul3czxGdcK6SS
 uQPvMlsFCeTrsxQKsPocGzuF6FkIqxwUK3PKRaMUYTtf9BoLpYEDLuNH0FHiydqkXxfB71IEWE7
 DoLBA0OE9emcB+Mk2FZl7mVG/
X-Received: by 2002:aa7:c384:: with SMTP id k4mr20307565edq.281.1635171393297; 
 Mon, 25 Oct 2021 07:16:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy0DabLqT08o64mSEkgU1uBZtZezVv5apPrWyd4apSmXmCs+LkrkYQ/fnsjY0W8O5UT62zRA==
X-Received: by 2002:aa7:c384:: with SMTP id k4mr20307513edq.281.1635171393133; 
 Mon, 25 Oct 2021 07:16:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id bx2sm3600770edb.44.2021.10.25.07.16.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:16:32 -0700 (PDT)
Message-ID: <01b5edae-aaa9-e96d-daaa-197c0c3a0431@redhat.com>
Date: Mon, 25 Oct 2021 16:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 43/43] KVM: VMX: Don't do full kick when handling
 posted interrupt wakeup
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-44-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-44-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 09/10/21 04:12, Sean Christopherson wrote:
> When waking vCPUs in the posted interrupt wakeup handling, do exactly
> that and no more.  There is no need to kick the vCPU as the wakeup
> handler just need to get the vCPU task running, and if it's in the guest
> then it's definitely running.

And more important, the transition from blocking to running will have 
gone through sync_pir_to_irr, thus checking ON and manually moving the 
vector from PIR to RVI.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
