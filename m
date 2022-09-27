Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0009FC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 22:06:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7987D4B210;
	Tue, 27 Sep 2022 18:06:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JfYKQnfOBN6d; Tue, 27 Sep 2022 18:06:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C8664B28D;
	Tue, 27 Sep 2022 18:06:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2C74B278
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 18:06:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4-BCTmJ6x-T1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 18:06:28 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C29A84B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 18:06:28 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 i15-20020a17090a4b8f00b0020073b4ac27so38677pjh.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 15:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=fauuNPDstfZWj568q3xiy+B2bGT91D8Yz04rERb5Agk=;
 b=bb6TqY4OGRLC3s4+XD5mAJ2HiSFhDxmZt3FTJEx4kw9/5yoX9bEwOhntdKQ202LEiB
 VP/RlohlCkOlNazikDGLqx+Kl3wBF5XhJI5sUt5VYhqRM2FXYT+oKfAmLVRM97ZRSWwm
 uq41IM9DNjiK38osgt3A7lvLEe04aA5+H1VU0igiLZKAt4dIDKlcT2HcMNBIAdgyGE/v
 uRiVDmSp0SFjcjxpnROFgl0MB4/Rgl49lnLUCs3MUVRpqpOXrVtVi18Q6GqcDHWDiOIP
 z5ePynT9lJKuhVMOrmRsSIlz95m0FrftDHNkyVgUICXo18CLg0plcPXDX5yTtTMNbJUN
 b0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=fauuNPDstfZWj568q3xiy+B2bGT91D8Yz04rERb5Agk=;
 b=mOzmLdrxPsGDtCfWtNAJ5XKuBbu31WjZVVra3iyNKfetaYHhF4ZXgdYWiFMPLXSr4d
 O3PJcUR6qlPDw3Fzg37crVYkNEuhDWmoSQ26pPMC/WLOzoJAEroCk38Sl3UfZoMTHtQs
 rXBhgw9ZxfF7yuXYUmJ+hQ9TCWFslr6THhbncOiXTLB0yOu1fT27KteNGEpxGOXeKuGY
 cHAzA3vh7INRby2X0ir1xkHWBlIXf3aUioJE1kzIBsKZjkD+IlDqOzjozQZ474+fmNqC
 hCgnDqr1IHuxwL8gL1rn8TFI7x1lpdktJqXEtwXCidaIt0fGRHBNv9oOUDbkU5GO2N6+
 J4fQ==
X-Gm-Message-State: ACrzQf1pYk80aLDvBJAYyDnAbRU5ciiFg+F5+fWpNWPtk6/dcY9epfc/
 OE/yx37E0qCTJaolb/DzjPLu1w==
X-Google-Smtp-Source: AMsMyM7axbyNIr4UEZ3eDvOk36cBFXytSk86ZlNroaL1fCDvwa8InsjXbITt4AIhy8bIIM3OVNR3MA==
X-Received: by 2002:a17:90a:650a:b0:203:a3a9:6b14 with SMTP id
 i10-20020a17090a650a00b00203a3a96b14mr6784620pjj.198.1664316387694; 
 Tue, 27 Sep 2022 15:06:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 g10-20020a17090a708a00b002007b60e288sm8834070pjk.23.2022.09.27.15.06.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 15:06:27 -0700 (PDT)
Date: Tue, 27 Sep 2022 22:06:23 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzNz36gZqrse9GzT@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com> <YzHfwmZqMQ9xXaNa@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YzHfwmZqMQ9xXaNa@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 26, 2022, Ricardo Koller wrote:
> On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > +	void *hva = (void *)region->region.userspace_addr;
> > > +	uint64_t paging_size = region->region.memory_size;
> > > +	int ret, fd = region->fd;
> > > +
> > > +	if (fd != -1) {
> > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > +				0, paging_size);
> > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > +	} else {
> > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > +			return false;
> > 
> > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > 
> 
> It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> page size. And note that the address is aligned as well.
> 
> madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> 	^^^^^^^^^^^^^^	^^^^^^^
> 	2M aligned	2M (hugepage size)
> 			
> madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> 			^^^^
> 			PAGE_SIZE

I think this needs to be root caused before merging.  Unless I'm getting turned
around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
