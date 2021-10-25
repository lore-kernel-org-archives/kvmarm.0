Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E24C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 15:48:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFFF560F70
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 15:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CFFF560F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E9C4B11E;
	Mon, 25 Oct 2021 11:48:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MlqZzFO6ibiZ; Mon, 25 Oct 2021 11:48:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7F44B0EC;
	Mon, 25 Oct 2021 11:48:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC2014B0DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 11:48:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sTtAlG5jiqIL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 11:48:30 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A000406E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 11:48:30 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id n11so8227696plf.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 08:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=0lZC/4YVNiq6m54gciVPWUG9HJx9IWHvMOAiOdASGoo=;
 b=QyfrOXYXYzIEyrLD44pl5e5qrBHvKskln3PRReuWzpAgV2++kLJzI050rqe2oVwX2v
 /YSSz3klIowpfUugVLMls4E5ALzM885A+JjaGYEd8dI6xPFGzSKWWGCwhTUoU1wJJ2+4
 q6QXjhMZdsCR4vmwSFpvR/7/SOjlriEKOoj6W/QPj/mWp9yfleITVSt3gv9SSl80X7Ip
 BvJTrYEOJKTHV3pbSlO8IHWn3hT4T3KR9LJVANxEXG1UOo91F4D+Bcp+BL0MB5OCLaKP
 Mo/ai6V2iZC0VqjsN2MnwKzxW/qxPY5ehn5rtVsOHSmvZ7PywSIV88EiySKFBzouQ+tc
 9/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0lZC/4YVNiq6m54gciVPWUG9HJx9IWHvMOAiOdASGoo=;
 b=yCJGU970hcTcOh7JQia9VwI847+v7glyMzb0TpTduKO56rddOuHSvHH9huBgIv7yc4
 9RCBsgQWagVRCqS7ChdTZKij/lxHEnlPhdY26rf8AHGfwT/j1UGJRtogw4HZ/YHahJN+
 uAgC1oyBh2HoBP3GRGl6iBQVEB0MgQdkChkC7b7p9OIkk5rJuMHdd9rUTC6kNXiTkbqN
 ydA5SeInZo9+ov/1IfGdXKpi0l9NnUKhJuxgrwoi94O1zfn86d+J2bOzNt802mJwV4V1
 Rwael9C8R5kEARZ2GZf7xP0dWbayapPm17C/xHCDtXieadHAi4RQJAFJJqB1BJAn6M+q
 o+aQ==
X-Gm-Message-State: AOAM530kcNdP0kW4YYaSJY0U3WmV4LHGc63Qscx51q7Lutg0gvNsYTZE
 ovTmy2VIa8WHbirECD8HmM2vVQ==
X-Google-Smtp-Source: ABdhPJxrKJ5kv/isPaW6TJ/VoEghKiV6FVNK9Q5PXIGPB6cKE19gMMU7U+s4ZFt4KBH5EHg4mjv+Qw==
X-Received: by 2002:a17:90a:bf0e:: with SMTP id
 c14mr5921807pjs.180.1635176908950; 
 Mon, 25 Oct 2021 08:48:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id g5sm11457677pfc.65.2021.10.25.08.48.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Oct 2021 08:48:28 -0700 (PDT)
Date: Mon, 25 Oct 2021 15:48:24 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
Message-ID: <YXbRyMQgMpHVQa3G@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-38-seanjc@google.com>
 <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > +	/* TODO: Document why the unblocking path checks for updates. */
> 
> Is that a riddle or what? :)

Yes?  I haven't been able to figure out why the unblocking path explicitly
checks and handles an APICv update.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
