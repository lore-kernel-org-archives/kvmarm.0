Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214F614B949
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722550981; cv=none; b=XxOP0PlwrWaPk9jKoI7RTX63XxyU79Ajrt4DdiOstRZmJOHYliB7vt/fikPj0X2Lv8vcbSkrUQ5Ozhrz0MpexcmNqtLp5CQTSzouB9Q7i4H323VIpXMc9QicXaN4+xMujye37lHFYKjZ0Hhi9AMijrnUxMuYE7SOXFqLFoc9B8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722550981; c=relaxed/simple;
	bh=83y5jcISbGVgHhdSye9Ayo9+ylHkjQBs4zkhSX1JibY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZiIip8LvZi3hxrnWddTFM0KyH3w25pMZ3HvXOP8os7+8hyeOQAXi1e1ono42giRm/XvRI8KT/cSstsl7lDi0fWe9FBpOJToT9mMxxJovBMW62EumAS/z4OIl4r2sVwjhePVNGIAvh1nBB05BQ4JbuBiOzi5ByDiQqltp/Zy6z84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i34z4aBH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i34z4aBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722550979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=acXEWndKlCVnwDNwF3qRu8zmTJbIkY9TPABZaKHwjrc=;
	b=i34z4aBHQMuaFPIEZPR7LjW7CPd+7B33wIa7So6so6IPMiBKXU93buLRzJ283hGDZ69J+1
	E+60RwKBnnAzk6mFLa/yl6vOP8GKmUDMEixo14mtHMn3+YUi48AsMP0kM/UEBhaX0CTzaM
	/jYQrEsmL8gtwchL476U5cT5KVDczNc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-9r19bqzEOZa7HXsWCScyOQ-1; Thu, 01 Aug 2024 18:22:55 -0400
X-MC-Unique: 9r19bqzEOZa7HXsWCScyOQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a1e23bb156so39046185a.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 15:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722550975; x=1723155775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acXEWndKlCVnwDNwF3qRu8zmTJbIkY9TPABZaKHwjrc=;
        b=IpFcNRoxLDe8IsaSwN5adkWpK73heM4Col15MH+mT9J+OLGAf/LrAfib6tqZKWES11
         6RHMUafv5SEI7g0LmiWrl6H+sx731FZ9TXlyhSOPZbvMki8hWkvf1FX0Ldmw4hVUBwI+
         6o9IRaP+xK9izoqFzEY6JkThAJ1FJHZPy82l2jaxXDKTSeG90WR9x400bGie4EMC6O/m
         VXvdyyGJ2/yTVy9QS05usnk9GcdD4LktajY20gzNsJI0pLd+y0A1f4TxK3BtA+VUMkwA
         feivGNmX40CT26KhX1IB7fVnbLFyY6FcGQhaaj8wY7rHyo3U3LaSyZzSbyDfUhFSOnkJ
         0yrw==
X-Forwarded-Encrypted: i=1; AJvYcCU98zVU/fTHubaFv0U5rjqf7TYqaGM+Vobv3edgx7kVvN+zTr/XkqbFXdWvoj+/RWx+El+h6t4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyM2MjQ8YPnSvzDJjB9E4n5u/9Lhki/TuTJJhiVITYIaupqW5Yn
	KJLfLjGtpi5YAzfjcTPNbFSDbzUiT+BEhhh6xogS6LcVTTASW6k0Kbiv7DCxd4XuXaYLFSwn+/e
	DWIdb3+VXMugDhRrbsXIXHt9jLt6+t+DkUgeYapzbXfa/36YpG471tg==
X-Received: by 2002:a05:620a:3902:b0:79f:78a:f7d6 with SMTP id af79cd13be357-7a34ef0f061mr104413185a.1.1722550975310;
        Thu, 01 Aug 2024 15:22:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEepfEQvZgBRjF0n6c40OJFUnxDJginkdVQ49bHtnVFZ0KbqFVRZ0T0eM1Jvx3otgOTXKNadw==
X-Received: by 2002:a05:620a:3902:b0:79f:78a:f7d6 with SMTP id af79cd13be357-7a34ef0f061mr104411785a.1.1722550974882;
        Thu, 01 Aug 2024 15:22:54 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f787aa6sm31839085a.103.2024.08.01.15.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 15:22:54 -0700 (PDT)
Date: Thu, 1 Aug 2024 18:22:51 -0400
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: kalyazin@amazon.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	roypat@amazon.co.uk, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults,
 KVM_READ_USERFAULT
Message-ID: <ZqwKuzfAs7pvdHAN@x1n>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-15-jthoughton@google.com>
 <4e5c2904-f628-4391-853e-37b7f0e132e8@amazon.com>
 <CADrL8HUn-A+k-+A8WvreKtvxW-b9zZvgAGMkkaR7gCLsPr3XPg@mail.gmail.com>
 <4cd16922-2373-4894-b888-83a6bb3978e7@amazon.com>
 <CADrL8HVuvBAMcuoifhjuSBpVOA3Av+_k4e=waD81ajKX4gXPHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CADrL8HVuvBAMcuoifhjuSBpVOA3Av+_k4e=waD81ajKX4gXPHw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Jul 29, 2024 at 02:09:16PM -0700, James Houghton wrote:
> > A more general question is, it looks like Userfaultfd's main purpose was
> > to support the postcopy use case [2], yet it fails to do that
> > efficiently for large VMs. Would it be ideologically better to try to
> > improve Userfaultfd's performance (similar to how it was attempted in
> > [3]) or is that something you have already looked into and reached a
> > dead end as a part of [4]?
> 
> My end goal with [4] was to take contention out of the vCPU +
> userfault path completely (so, if we are taking a lock exclusively, we
> are the only one taking it). I came to the conclusion that the way to
> do this that made the most sense was Anish's memory fault exits idea.
> I think it's possible to make userfaults scale better themselves, but
> it's much more challenging than the memory fault exits approach for
> KVM (and I don't have a good way to do it in mind).
> 
> > [1] https://lore.kernel.org/lkml/4AEFB823.4040607@redhat.com/T/
> > [2] https://lwn.net/Articles/636226/
> > [3] https://lore.kernel.org/lkml/20230905214235.320571-1-peterx@redhat.com/
> > [4]
> > https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/

Thanks for the link here on [3].  Just to mention I still remember I have
more thoughts on userfault-generic optimizations on top of this one at that
time, like >1 queues rather than one.  Maybe that could also help, maybe
not.

Even with that I think it'll be less-scalable than vcpu exits for
sure.. but still, I am always not yet convinced those "speed" are extremely
necessary, because postcopy overhead should be page movements, IMHO.  Maybe
there's scalability on the locks with userfault right now, but maybe that's
fixable?

I'm not sure whether I'm right, but IMHO the perf here isn't the critical
part.  Now IMHO it's about guest_memfd is not aligned to how userfault is
defined (with a mapping first, if without fd-extension), I think it indeed
can make sense, or say, have choice on implementing that in KVM if that's
easier.  So maybe other things besides the perf point here matters more.

Thanks,

-- 
Peter Xu

