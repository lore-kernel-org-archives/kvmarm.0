Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434FF8BEC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 17:48:34 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso10353635pjp.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 09:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5xoN11pX4OSnajsl6E0NBnPLkwNq7Bwr0irfBiF1lwY=;
        b=ItrMDLIG/W96FYEM6q//zgLFYJO3d+CGzfX4g1QGRgww6FJF/s1qppSMFNPa+UPp5k
         8YW0T1ueCrox+4Na/HWnwCPiQIs4f6SpXXKdo3ADbbdupX7Pe8+5T0WyiVG4Ahrxj4ti
         DbIc9e1nOoU2PX9juVde04Fby/qMyGJJqr2w4mG/cwoF2Cwc1gqY92xe1Hq4zK9lE1xe
         1Byete1jdRfrjvhNWRCAsenKnwImkQ0dXxaIIOVS5z3sN2URSGnC6yRwRXjllSaSZ7u5
         Qe/36/dgMw9oUl+O9vqrZgisUNEx5HjdwHEipkA8qmSbLVkLy2E1aV7xe4VJjweZ51CU
         f9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xoN11pX4OSnajsl6E0NBnPLkwNq7Bwr0irfBiF1lwY=;
        b=stxUbV8m95NqQw9YPBB/YNf8VMCwzsEV8gu+hZ+MXddglxMZxeYQh+X/JcqbFnoddw
         nGuXdFihzysOxWphpz8L1hk7/Y4itVbD8J13sCth86MrPKVT2NRmqI36IHqEFBD2nH8R
         YLN6JjdoYUOT8objZB89lY/iPClOCt0BjuZL9YSSu6W3ixXB7Ilv91M5O6S0JfRhbl85
         DiMKH8cgO3Dgr1At7RQNxMrEpd2UWZJcExtz3He/bWC93TZKXq5ep67u651h7DmY1Tgt
         PuUx+h/zkgELHzXd8r7mhz+zQxy9MXXFfRAwJeWRnmwAAY0jeHQD1mZbAWPI10fh460M
         boww==
X-Gm-Message-State: AFqh2krGjCRhz0RbD3rIzwKniRTjOSlijBZ9aiE55fTJy/h81efZ4S+U
	dl30ycUWUeQLnIwgeX9hFnfyPA==
X-Google-Smtp-Source: AMrXdXvjEZDf2VJ18a62toCaDtf7dF86OPQzK4KO9QoB7HmzYCHrV7Wcnr/m/Gb08ScERGltCtKo+g==
X-Received: by 2002:a17:902:b413:b0:192:6bb1:ed5a with SMTP id x19-20020a170902b41300b001926bb1ed5amr26589093plr.38.1674582513517;
        Tue, 24 Jan 2023 09:48:33 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id o6-20020a1709026b0600b0019602dd94f1sm1962213plk.13.2023.01.24.09.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:48:33 -0800 (PST)
Date: Tue, 24 Jan 2023 09:48:28 -0800
From: David Matlack <dmatlack@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Ben Gardon <bgardon@google.com>,
	pbonzini@redhat.com, maz@kernel.org, yuzenghui@huawei.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y9AZ7ORdmIPQ1YGL@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
 <Y9ALgtnd+h9ivn90@google.com>
 <Y9ARN5hWlAYVFBoK@google.com>
 <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>

On Tue, Jan 24, 2023 at 09:18:33AM -0800, Ricardo Koller wrote:
> On Tue, Jan 24, 2023 at 9:11 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Jan 24, 2023 at 08:46:58AM -0800, Ricardo Koller wrote:
> > > On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:
> >
> > [...]
> >
> > > > Would it be accurate to say:
> > > > /* No huge pages can exist at the root level, so there's nothing to
> > > > split here. */
> > > >
> > > > I think of "last level" as the lowest/leaf/4k level but
> > > > KVM_PGTABLE_MAX_LEVELS - 1 is 3?
> > >
> > > Right, this is the 4k level.
> > >
> > > > Does ARM do the level numbering in
> > > > reverse order to x86?
> > >
> > > Yes, it does. Interesting, x86 does
> > >
> > >       iter->level--;
> > >
> > > while arm does:
> > >
> > >       ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> > >
> > > I don't think this numbering scheme is encoded anywhere in the PTEs, so
> > > either architecture could use the other.
> >
> > The numbering we use in the page table walkers is deliberate, as it
> > directly matches the Arm ARM. While we can certainly use either scheme
> > I'd prefer we keep aligned with the architecture.
> 
> hehe, I was actually subtly suggesting our x86 friends to change their side.

Yeah KVM/x86 and KVM/ARM use basically opposite numbering schemes for
page table levels.

Level | KVM/ARM | KVM/x86
----- | ------- | ---------------
pte   | 3       | 1 (PG_LEVEL_4K)
pmd   | 2       | 2 (PG_LEVEL_2M)
pud   | 1       | 3 (PG_LEVEL_1G)
p4d   | 0       | 4
      | -1      | 5

The ARM levels come from the architecture, whereas the x86 levels are
arbitrary.

I do think it would be valuable to standardize on one leveling scheme at
some point. Otherwise, mixing level schemes is bound to be a source of
bugs if and when we are sharing more MMU code across architectures.
