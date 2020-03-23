Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379E7C54FCE
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E09C320735
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRrPTNW/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E09C320735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 994EE4B0B5;
	Mon, 23 Mar 2020 09:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WTnVIxBFsJBx; Mon, 23 Mar 2020 09:35:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2E64B0D6;
	Mon, 23 Mar 2020 09:35:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 014A64A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:48:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UrFSrAX-dmAX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 08:48:47 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [216.205.24.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 189BA4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:48:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584967726;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jT01buco6uzW21meg0B5Msg/Bm4GIl6gV7g2Ambj934=;
 b=TRrPTNW/R1NsO3LwnelNOuoDFR+wCYTOqfKYhNeWyriNxid9WzWNQrjNim2cWGB0I0uHhh
 y8GDBT/atb8qLOcDdbdzdK2OgzKphQWgSjh+a0HxeVmbJbDtNctkijkCFIh8WQK+KOJzJq
 heRVxcFw0At/9ZPF21pQUUt8dOMjQFc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-4ZHkjmy5O2GFEebBji7xRA-1; Mon, 23 Mar 2020 08:48:45 -0400
X-MC-Unique: 4ZHkjmy5O2GFEebBji7xRA-1
Received: by mail-wm1-f72.google.com with SMTP id g9so1899089wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 05:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=wF/Z91rii7js9BxWiPX/IJSf6cOn716YQpoQOgnhvlY=;
 b=Mkammpv9bsOKZjPYBtdBMdlQCRrTCsHJCofzJcOPqAnuBaMERvrpro+EO0KoBwcwqh
 LaUJy88EepY+BzBudwiu7oH9y15nnfomnTtZ83OIfnTKMtxhjSrTwsLIn2fQYK7fpqEK
 OpXdv4nlU0LNqhKiy7thqKvu0sZUwYBxYdw8AZnUOn7GrNiODQMEVESHXRJhjZUBOJ7p
 EO1mgtXsZYOkmgo1ScxSd+ufODNeErkxsg+e6U/XxFlDocK+Uh07k+SRa0+i/XUaIQUW
 G6/axcrIxGAsxcnBc32rBKmWbyfRcR7rQk+RyTcAnry+oP44L5gYSM0/MUe9d8v+OVXi
 dVQg==
X-Gm-Message-State: ANhLgQ0zK1nX15ox2l2eYzHGhzVdlEp5ybhbn6sKxYQ8fLdkqT+An78+
 bgELmeWjt+INyHKjXe8epxsuKoyoFL4OUt2Yri1IF6CqFqBl65P6Fvtfl7gL2wOO+ZbxlljDjMq
 4RkeOK3DSKH5o0w8is2WCLavx
X-Received: by 2002:a1c:5544:: with SMTP id j65mr25700709wmb.60.1584967724307; 
 Mon, 23 Mar 2020 05:48:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsE+BwUdC/3N3MhWCg3gX3gw8CdW/xveukJtA9Qqd5DxMyzUeCK03I5juokdRkfNo1dgo0DkQ==
X-Received: by 2002:a1c:5544:: with SMTP id j65mr25700677wmb.60.1584967724024; 
 Mon, 23 Mar 2020 05:48:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id j39sm24686004wre.11.2020.03.23.05.48.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Mar 2020 05:48:43 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 9/9] KVM: SVM: Annotate svm_x86_ops as __initdata
In-Reply-To: <20200321202603.19355-10-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-10-sean.j.christopherson@intel.com>
Date: Mon, 23 Mar 2020 13:48:41 +0100
Message-ID: <874kuf9qza.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 23 Mar 2020 09:35:35 -0400
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Tag svm_x86_ops with __initdata now the the struct is copied by value to

Same typo, "now that the struct".

> a common x86 instance of kvm_x86_ops as part of kvm_init().
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b61bb306602b..ab2a1cf6c188 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7350,7 +7350,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
>  	avic_update_access_page(kvm, activate);
>  }
>  
> -static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> +static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.hardware_unsetup = svm_hardware_teardown,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
