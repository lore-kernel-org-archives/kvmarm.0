Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02344C8A
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 15:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666108268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BoKkcuxL5NREz5vjMqNcHiKa9FwvH6HgAB/kBFDCW9w=;
	b=g/rhxnw/2kh8Kge3uMnNDqKfCpfX0B/mmIlKX4MVIpNu+9+/Gfnxw8X9R7bdDG2oj+PV7n
	aATi+QhrmHe0oT3Jf0r3nnmKpewVt/Nn9VfKfEhmwtcb1bzmRLGo4ajBmt8L7Ufx1/hzj+
	6thlgUrnNwpj8wHPDvSi7FyKlxCprUE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261-DNdPJk5kM5i8RhBdrKCNUA-1; Tue, 18 Oct 2022 11:51:06 -0400
X-MC-Unique: DNdPJk5kM5i8RhBdrKCNUA-1
Received: by mail-io1-f70.google.com with SMTP id 23-20020a5d9c57000000b006bbd963e8adso9826166iof.19
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 08:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoKkcuxL5NREz5vjMqNcHiKa9FwvH6HgAB/kBFDCW9w=;
        b=Ft3wH4DwNclN5KbGn1048i2SXOE34NpfsFWqY6F9wGzWuB+VL6iPPJNz11oQh783mE
         2rbD6MCXY79DLsO1sgfLqvoKX6/MTVJ4miamWrzqxw2+jFjmv9NqhHlyygq4BphOMVoI
         oKgkYiEPN8wfOv/OoQdEPcAvX2ucysn2fIv2lpBBuOhgEGib7OwUyMlCShFAk714MbQA
         RHl5czxzGF0VS91RTv3trq05VtB84p7kvKjsO5GjZAukDMKXVLDg+fGYKhu2oxbRzKNP
         DKNTG35Olr3GGpyVdmvQwaHvGDTzSTRQyoF54P2A7L11AmISroeg6bPR0ug4Sc1FP3Qg
         eKVQ==
X-Gm-Message-State: ACrzQf2Tl1RnWawoJabMpZRxNlnTgE+93zLldCjbNVTBJDmFg2R6Ay/s
	pyICMI/WhmjwP9r6jI6mUXYJYdH7m6IdqYt6Db6QmLPd29YwO0vGNMdpe1OBbeeA9Y7kfYoOCwK
	ZMYx/E0ArI4Xs3Tki
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id p3-20020a056638190300b00363e8242193mr2260587jal.40.1666108264900;
        Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7rTkkIhDBNg5wS6havwCc+dTDzEUFDvH98GZ+b7II2SM5/9WtuFcl6vpreWjVh7ZL84I5kVw==
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id p3-20020a056638190300b00363e8242193mr2260559jal.40.1666108264633;
        Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id h39-20020a022b27000000b00363c866d646sm1188924jaa.26.2022.10.18.08.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
Date: Tue, 18 Oct 2022 11:50:59 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
	andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
	pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, seanjc@google.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y07LY41y6ZRL3d3S@x1n>
References: <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local>
 <Y0TDCxfVVme8uPGU@google.com>
 <Y0mUh5dEErRVtfjl@x1n>
 <Y05X4o1TxxkvES9E@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y05X4o1TxxkvES9E@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221018155059.TGyqo18Fk_pkEIEZZ_016yPLKxFs-owZRPA27cRqYkA@z>

On Tue, Oct 18, 2022 at 10:38:10AM +0300, Oliver Upton wrote:
> If we ever get to the point that we can relax this restriction i think a
> flag on the BITMAP_WITH_TABLE cap that says "I don't actually set any
> bits in the bitmap" would do. We shouldn't hide the cap entirely, as
> that would be ABI breakage for VMMs that expect bitmap+ring.

I'd rather drop the cap directly if it's just a boolean that tells us
"whether we need bitmap to back rings". Btw when I said "dropping it" I
meant "don't return 1 for the cap anymore" - we definitely need to make the
cap macro stable as part of kvm API..

But I think I misunderstood the proposal previously, sorry. I assumed we
were discussing an internal HAVE_DIRTY_RING_WITH_BITMAP only.  I noticed
this only after I had a closer look at Gavin's patch.  Having a cap exposed
sounds always good to me.

I'll comment on Gavin's patch directly, thanks.

-- 
Peter Xu

