Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA36C6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 16:03:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 563B44B6DD;
	Tue, 27 Sep 2022 12:03:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6p3vfLraJnVM; Tue, 27 Sep 2022 12:02:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC944B647;
	Tue, 27 Sep 2022 12:02:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E4C04B633
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 12:02:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d0Lml4Y8v+JQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 12:02:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E944B647
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 12:02:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664294577;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=WtpRxtCZltp/63OXQYG8Mzy798EcRnh/IHqJ0/4DV1E=;
 b=RomP5WKJlIC+jfzLBLDvrYpCf8AtoWNS648VFn2aCne7pY4VWfla0OvvhMBbAUk9xSwnrU
 2RyRZT1kLcVXeSbRj5yZiA18avqP7KR11uE/qSXfTQV/blSzucrUda3O7MpMKDWPaHpi62
 uHBQJL1J/SKmAdVmZW5A4AdDITikgjA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-375-gbV8PPPPN0S-ZtGOVQqR1w-1; Tue, 27 Sep 2022 12:02:56 -0400
X-MC-Unique: gbV8PPPPN0S-ZtGOVQqR1w-1
Received: by mail-qk1-f198.google.com with SMTP id
 d18-20020a05620a241200b006ce80a4d74aso7584952qkn.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 09:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=WtpRxtCZltp/63OXQYG8Mzy798EcRnh/IHqJ0/4DV1E=;
 b=pgXhLz+uIz2LMiIAQCKTfUfzk3Bm3705R7u+rvZfplvpdjRf8Fyg8c1+sUAB1zCSRm
 Naq1wmcmWNs6X6j5be+w38R4Nl7JXhfAf8QntkUwsltM8n/A2/8QMeJTXq0wFF5UU6Zs
 V0qjCrdYk736Ztdls+jzS3TZL1VoTa+M6Nzwzo5qw84U+f/ps/QWTye2LsZldk/klXlI
 4/OsjjYsvbjtc8L8k8unaJriURfCVo4p8HnMEJnYyWdqsxf0rpARFTToABBUdcDKfn0H
 XI+gJepWw7My+Hg+Qxp+bVYypHQFFchSM+WOMbPaeMooi60Ply1GSKDQ9fYriXU5HQiy
 v9Yw==
X-Gm-Message-State: ACrzQf3MJhKplt98QFuKUmOnHleug0KJx1deANNt+mZ7qH9yuQyFW4fN
 mbky+KE7fnpTOkKN3PxOcpsu93bubuUjF256kqvy28BO6sjVG3TmBZjff+3BMb14R2lBLXGqNKG
 lxakVhP1oP14DOOhCAc47EjEJ
X-Received: by 2002:a05:6214:21cb:b0:4aa:b039:35c7 with SMTP id
 d11-20020a05621421cb00b004aab03935c7mr21789005qvh.60.1664294575442; 
 Tue, 27 Sep 2022 09:02:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6lmFS0nvurnTtO5d5O/P/pgdsV3Q8A7e7qy/mOBjQiXB4CjUnTlFBCMrFl3cnsQiwSWkf9+w==
X-Received: by 2002:a05:6214:21cb:b0:4aa:b039:35c7 with SMTP id
 d11-20020a05621421cb00b004aab03935c7mr21788957qvh.60.1664294575072; 
 Tue, 27 Sep 2022 09:02:55 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 n19-20020a05622a041300b003434f7483a1sm1083235qtx.32.2022.09.27.09.02.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 09:02:54 -0700 (PDT)
Date: Tue, 27 Sep 2022 12:02:52 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YzMerD8ZvhvnprEN@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220927005439.21130-4-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 27, 2022 at 08:54:36AM +0800, Gavin Shan wrote:
> Enable ring-based dirty memory tracking on arm64 by selecting
> CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL and providing the ring buffer's
> physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Gavin,

Any decision made on how to tackle with the GIC status dirty bits?

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
