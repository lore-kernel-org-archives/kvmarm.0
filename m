Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC86533F7
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682089097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7LC096k61C4co5uiqlVvGHf+K8GD+8vxgAbqEN6QsgQ=;
	b=cFgggTHnbYBNEqPX3qFGTXQOFtX/2cp/L/6vI9tm3IQ9aQUDMVO+G3vA+1sDSARglHa9zH
	yU4IuBa5y5s7VVAD+rma4j3q8LiT5ag9CnMZ6tiyZONSDaeL4KhQF4XvdD4KUcjmksVO0N
	9e9KLxN0I5kpDdGokNAtzbMD9x5RhY8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255--rk37soOOQSYsXdSjb-1Sg-1; Fri, 21 Apr 2023 10:58:08 -0400
X-MC-Unique: -rk37soOOQSYsXdSjb-1Sg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ef4f29c9d1so4863081cf.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 07:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682089087; x=1684681087;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LC096k61C4co5uiqlVvGHf+K8GD+8vxgAbqEN6QsgQ=;
        b=jCNEEaYjKV5vjRlJmpjrhQTXlj8Old6mba9p/OFGVXgDnYRNuswnMCvrLKiAdh3Wr8
         yGjtHAziu9YbQRP7p26Y8luI0ymlrvWIxz8wNjtqu+pk1WUCiJ1XoxxZuDv69FssYx3+
         KwruSj+cpBa6vhVqnnRpM27yXku96mSPcHqevS0sfNWpreuAiSkg6Q6DmLfwSD6akYQ7
         gjcNzHRNnJZI+KV/UseHraAvWi7a71zSUPMi0KMw4LKinriOQVUVD/k7UI95cAGlnvoR
         Rsjeo/ZPeQQ846F8hbZzLRGoHi1dn9HNla2U+DkvXwgq0BmAjrdagqiv/m71oNumTcui
         AkTw==
X-Gm-Message-State: AAQBX9c9Svkd5PjcfkpluNPbRqg7ldLHmVLkOJRn6iKl1xt8UjuWRGn6
	U9Oukj+3duIU1Kui0WbMnMqbT08tCjE2MnVctCleHsPlonW6UchpXkcSMo8vO9Z+Pu3/Wq7Eobz
	CaKg4/JvLySKaKb6T
X-Received: by 2002:ac8:7d06:0:b0:3ee:5637:29be with SMTP id g6-20020ac87d06000000b003ee563729bemr10128344qtb.5.1682089087583;
        Fri, 21 Apr 2023 07:58:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z+IcubMRrk1IJq5k7fg+CwcAga6nlSsWwbEUJWDqsGTpE2BqXmuDYKV5JvxqtA2eOIr2WmoA==
X-Received: by 2002:ac8:7d06:0:b0:3ee:5637:29be with SMTP id g6-20020ac87d06000000b003ee563729bemr10128329qtb.5.1682089087331;
        Fri, 21 Apr 2023 07:58:07 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id y7-20020ae9f407000000b0074e0e6aae1csm1385221qkl.36.2023.04.21.07.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:58:06 -0700 (PDT)
Date: Fri, 21 Apr 2023 10:58:05 -0400
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
	seanjc@google.com, jthoughton@google.com, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/22] KVM: Annotate -EFAULTs from kvm_vcpu_map()
Message-ID: <ZEKkfa5vitypkRxU@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-10-amoorthy@google.com>
 <ZEGmWrnqI3SBUW7A@x1n>
 <CAF7b7mq-9yOqCRsJ96dm7NMFMLOYw=Q=Q5gMWukpde9ZqQCAEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAF7b7mq-9yOqCRsJ96dm7NMFMLOYw=Q=Q5gMWukpde9ZqQCAEA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 20, 2023 at 04:34:39PM -0700, Anish Moorthy wrote:
> On Thu, Apr 20, 2023 at 1:53 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Totally not familiar with nested, just a pure question on whether all the
> > kvm_vcpu_map() callers will be prepared to receive this -EFAULT yet?
> 
> The return values of this function aren't being changed: I'm just
> setting some extra state in the kvm_run_struct in the case where this
> function already returns -EFAULT.

Ah, I was wrongly assuming there'll be more -EFAULTs after you enable the
new memslot flag KVM_MEM_ABSENT_MAPPING_FAULT.  But then when I re-read
your patch below I see that the new flag only affects __kvm_faultin_pfn().

Then I assume that's fine, thanks.

-- 
Peter Xu

