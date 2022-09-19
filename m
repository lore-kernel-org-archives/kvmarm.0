Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C89ECAAD3
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 16:17:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2824B64E;
	Mon, 19 Sep 2022 12:17:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DNMtGYRMaNZF; Mon, 19 Sep 2022 12:17:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0EA4B62F;
	Mon, 19 Sep 2022 12:17:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F39614B615
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 12:17:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2TrS7PGbblMC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 12:17:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B28334B5F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 12:17:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663604227;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Xn5fnqKtyryYA5w5sfE3wIiUTcmcdDi6qpfcSbkJ4Lw=;
 b=R10g2q7MF069L96xyxjbx86o6FVyu4S0FAG/4+qRdbU1yYZ4JlzKbnSRyHeTPm5rOqWdi1
 2V+mUuaLpQqlTNmjZcjsYiFLmIfLGQ/jP356MtQ0Ut6wX5Y3n+mUC7bzj7DZnCJHXMqrmf
 nIAon8/sbTvv7sJfAxuar2nPyYQ+8Qo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-179-7aqrwZw0MjWj-pSsQHGsZA-1; Mon, 19 Sep 2022 12:17:05 -0400
X-MC-Unique: 7aqrwZw0MjWj-pSsQHGsZA-1
Received: by mail-qk1-f197.google.com with SMTP id
 u6-20020a05620a430600b006ce769b7150so15330558qko.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 09:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Xn5fnqKtyryYA5w5sfE3wIiUTcmcdDi6qpfcSbkJ4Lw=;
 b=YuM9np5OyINmwHdho+tDcmYz6Ix/MKufFDhEs4e1s+24pub7Q14DjwfbpOZWfGLSzJ
 4AlJgUA0IdiV6+qLeNNbYz2ygyCfEldizEALKmgB7n5m4Tx+bCWqng5C7RorAiFV74z5
 oIVDVuLoBsSFYqpZZDgvv4CY4LtO0qjhd0zVkK0kd06plUkdurdsRsn7R1asodJKWUlH
 VWa9RjKuncFCwxlJNKetU2v4nK9/Rq+0QDhdrIEYKH0BSlAUR8NfrsKdqaVKH9bxeEJ5
 7aO/BDeNSR6DD2yAHIMSj8lCi/YF/b8okwLmSi88hkWuyewQZfCoKZMRhtEYgBDu1Okp
 NQow==
X-Gm-Message-State: ACrzQf0Jcju13yQfetuoVDDeyuTysWkfzpsm7RrHeb+Hr0IYgvvAO2g/
 +t/wgKe930EOX+lRbW/Oj3lrowjSdjXPrRR1cXXra/dm9ofrWFKQcB3FFaq7OUifi2L5pWgJITT
 LD0zGDN7HuXgu3Qv66OKDEeBf
X-Received: by 2002:ac8:5e0a:0:b0:35c:e8d8:6c19 with SMTP id
 h10-20020ac85e0a000000b0035ce8d86c19mr5068675qtx.178.1663604225357; 
 Mon, 19 Sep 2022 09:17:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM51+LmYDmB5JjErlr4hYbacMbbiBwggTg81wkAjJVlWGP8agHsUu4S5cY7WS6QJw0cvQ6qJIg==
X-Received: by 2002:ac8:5e0a:0:b0:35c:e8d8:6c19 with SMTP id
 h10-20020ac85e0a000000b0035ce8d86c19mr5068640qtx.178.1663604225144; 
 Mon, 19 Sep 2022 09:17:05 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
 by smtp.gmail.com with ESMTPSA id
 bv12-20020a05622a0a0c00b0035cf2995ad8sm826570qtb.51.2022.09.19.09.17.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Sep 2022 09:17:04 -0700 (PDT)
Date: Mon, 19 Sep 2022 12:17:02 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 1/5] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <YyiV/l7O23aw5aaO@xz-m1.local>
References: <20220916045135.154505-1-gshan@redhat.com>
 <20220916045135.154505-2-gshan@redhat.com>
 <YyS78BqsQxKkLOiW@xz-m1.local> <87illlkqfu.wl-maz@kernel.org>
 <a2e0b9bc-2c67-8683-d722-7298bd65058c@redhat.com>
MIME-Version: 1.0
In-Reply-To: <a2e0b9bc-2c67-8683-d722-7298bd65058c@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: corbet@lwn.net, drjones@redhat.com, shan.gavin@gmail.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 bgardon@google.com, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 will@kernel.org, linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
 dmatlack@google.com, pbonzini@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Sep 19, 2022 at 09:58:10AM +1000, Gavin Shan wrote:
> I think Marc's explanation makes sense. It won't make difference in terms
> of performance. We need to explicitly handle barrier when kvm_test_request()
> is used. So I prefer to keep the code if Peter agrees.

No strong opinion here. I keep thinking clear+set look awkward even if it's
unlikely path to trigger (ring should be recycled when reaching here for
any sane user app), but if it's already 2:1 then please go ahead. :)

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
