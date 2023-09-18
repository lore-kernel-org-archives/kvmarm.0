Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8769622F1F
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 16:17:52 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-576918d0a42so2825488eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 09:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695053871; x=1695658671; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2rBowV5k7lk2ieUe+gHPEvDWhBOkpthR4x1/BaQpS1E=;
        b=kiKorsg2aJsiUYEx5K3WptXyW/UfUBUZ33rNSJeS8XvrIcMorDv37AR2ofen4onUwY
         hte5a10HwN3MQlaVA8TsqEuMCy+dfpIr+M+NO0lXd+iqOO+H16LYldBXgl6RrceS3jEM
         RSYSmf9g9QIrVO3kl4DPXA7hNOFJc0PEY5kCK2Kq12X8sy68FONR7y+c4tn4fMratUgg
         7SRb7BEV2FDHFvpeyUFidBL2MMdoneYLVtfJm51oGqM7kTeUEQFKPjRR8DJBOc3ipgC0
         j4V5u1bZ4pfC8nB6BLZ8DkaW1xyaO8eRfXfETwAFy/my3Bb8VNOrW8CronGMpmC6D2Fv
         1JvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053871; x=1695658671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rBowV5k7lk2ieUe+gHPEvDWhBOkpthR4x1/BaQpS1E=;
        b=ZNt6xOQOKPUY0uQn2iMbASyKU7t3RBk5ZtZHTatRjwfkKcp4ceJPeaB1hoK7PDtiZM
         69mEysilKHV8RD6sRTTp7i/xMku4Dbe8mJdCqBFVs/Ar0mUU5UE5WNhcPdfjvDbuiCSt
         zaK2rpIaIep+0N1o/5s6eG/u7g+fdt0mpf/gOzT5K2+AWnZNX3xr/TdB09x58bIwj4rh
         7zPY80K4MaedVGvB0guHDHdhtUTv1MVkFIpnTkMHJLEmzQW8NMH72gvqyropxiLCKmfm
         xdVyUEbRNdNWs4S6bN67J6BSL2ph9NMJ2Rgg2EA8H+bt5uSlLhCxS4eP3dCIuw/0fhnI
         UAxA==
X-Gm-Message-State: AOJu0YydSilC1hneT2+9sUxvNWiEWBejxMjuigb/mxov0Lx24MhpwlKw
	VOP2UW6flStnEJd49IBvklBhow==
X-Google-Smtp-Source: AGHT+IEIIPi01LMzDkzmjlUBhug1qKaxU6nRjVuZ+XGbMUgkxm1Qfw0TLzJDUPnbwFfEuT1QKajmag==
X-Received: by 2002:a05:6358:7207:b0:13f:411:c1a9 with SMTP id h7-20020a056358720700b0013f0411c1a9mr13490229rwa.17.1695053871422;
        Mon, 18 Sep 2023 09:17:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id pz10-20020ad4550a000000b00656260e67afsm3340834qvb.115.2023.09.18.09.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:17:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1qiGwY-0005mj-Ao;
	Mon, 18 Sep 2023 13:17:50 -0300
Date: Mon, 18 Sep 2023 13:17:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, kvm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Anish Ghulati <aghulati@google.com>,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 06/26] KVM: Drop CONFIG_KVM_VFIO and just look at KVM+VFIO
Message-ID: <20230918161750.GM13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-7-seanjc@google.com>
 <20230918152946.GJ13795@ziepe.ca>
 <ZQhySMjmuyW2Czas@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQhySMjmuyW2Czas@google.com>

On Mon, Sep 18, 2023 at 08:52:40AM -0700, Sean Christopherson wrote:

> > I wonder if we should be making the VFIO drivers that need the kvm to
> > ask for it? 'select CONFIG_NEED_VFIO_KVM' or something?
> 
> I wondered the same thing, if only to make it easier to track which
> drivers actually end up interacting directly with KVM.

There are two usages I've seen..

GVT's uage is just totally broken:

https://lore.kernel.org/kvm/661447fd-b041-c08d-cedc-341b31c405f8@intel.com/

It is trying to use KVM to write protect IOVA DMA memory, and it just
doesn't work. If we want to do something like this the core vfio code
should provide this service and it should be wired into KVM
properly.

power and s390 have actual architectural "virtual machines" and they
need actual arch operations to install VFIO devices into those
things. In this regard having the arch opt into the integration would
make some sense. I expect this will get worse in our CC future where
VFIO devices will need to be passed into arch specific CC code
somehow.

This arch stuff isn't cleanly done, the code is sprinkled all over the
place. Some in mdevs, some in PCI arch code, some in #ifdefs..

Maybe the CC people will clean it up instead of making the mess bigger :)

Jason
