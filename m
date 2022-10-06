Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED67DC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Oct 2022 20:28:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA34411BD;
	Thu,  6 Oct 2022 16:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9CNeHXB0D+ow; Thu,  6 Oct 2022 16:28:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBFE74089F;
	Thu,  6 Oct 2022 16:28:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D37BC402A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 16:28:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JibfDILLgdPd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2022 16:28:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86FF3401D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 16:28:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665088135;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PzDMEFf3RvC/4HsJdVTaIeB4nK1mYRC18rZsRN9dEDk=;
 b=VoH62hCJa2RoKQcbEqdvfwkYiC/8BaDTZ8InNS5DmDSVDk6NZ7rEoIKEcZ6e4LVLtioXrT
 +yHejgisU4JCsUfWwFUhelutULiC2hROPH+xasjWPg5mEQsL5sRb59SR7rqUsiKzFJyLFS
 c0JE5sosPIa8rnRMe9ugNk7t06B7ojM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-398-JgHqwl6_MmuXMLvyvs1Q2A-1; Thu, 06 Oct 2022 16:28:51 -0400
X-MC-Unique: JgHqwl6_MmuXMLvyvs1Q2A-1
Received: by mail-qt1-f198.google.com with SMTP id
 u14-20020a05622a17ce00b003947c24705dso1548643qtk.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=PzDMEFf3RvC/4HsJdVTaIeB4nK1mYRC18rZsRN9dEDk=;
 b=J4Tv9EfSXaeYAxpcLWpFs5JxY8vIOmlj45rb41AXimpI5fqWXqx5egwi9S+1nSeIZ6
 WiBt8hXqsjo+ybnW1Nr6xXOTsouns+RdvRf0moCuwaGmnASP/GGd7wBOQSCCSjia3M68
 Q7EhtPkP6zGKAyNRusIk7e0+T1OrVEuxDwD5wfCA34JHam5c9LSegUjWL/YpvzVI7WBA
 mlI+Bhb4TXtzo1xNf1VHJQHPnLqubxHtzSmHDCFNbVrebnVjbZH6wlHKZjobFj3BAG8E
 dePHNyfDSu3ThtlamuM4JornincG1cNmbhwPP1ONCCfRw+r11lJsHQ8Lx+3k48SSnKjJ
 TSYg==
X-Gm-Message-State: ACrzQf2Hr7bnKjyPBRV/LEkibsE3wBd4J5droHQ0QkdP3Nta60IXiGbF
 Fua7Utv3WhFQlef8Xv8QDVGM9z1OPn4OAZG2CLZ2W6ECaSIVUZic6jelZjyloRXpRyZykF8RwLS
 nwIPrCAgPN4nTbMov8ldsOyHg
X-Received: by 2002:a05:6214:d8b:b0:4b2:f6f4:bf5b with SMTP id
 e11-20020a0562140d8b00b004b2f6f4bf5bmr471087qve.91.1665088131467; 
 Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7wdSO+0rTVDOZDD3Csrns1eNjrxa7fASHygvAI0zZa7rTZmRLseTk486PcRmkPdgJRBXB+uw==
X-Received: by 2002:a05:6214:d8b:b0:4b2:f6f4:bf5b with SMTP id
 e11-20020a0562140d8b00b004b2f6f4bf5bmr471062qve.91.1665088131285; 
 Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 o19-20020a05620a2a1300b006cddf59a600sm74769qkp.34.2022.10.06.13.28.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Oct 2022 13:28:50 -0700 (PDT)
Date: Thu, 6 Oct 2022 16:28:48 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Yz86gEbNflDpC8As@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221005004154.83502-4-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
> -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> -----------------------------------------------------------
> +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
> +--------------------------------------------------------------

Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
being enabled first, instead of making the three caps at the same level?

E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
(x86).

> @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> -	/* Dirty ring tracking is exclusive to dirty log tracking */
> -	if (kvm->dirty_ring_size)
> -		return -ENXIO;

Then we can also have one dirty_ring_exclusive(), with something like:

bool dirty_ring_exclusive(struct kvm *kvm)
{
        return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
}

Does it make sense?  Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
