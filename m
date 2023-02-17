Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8337F;
	Fri, 17 Feb 2023 08:02:34 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id o3so71885pga.1;
        Fri, 17 Feb 2023 00:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5phApT5KIAC+uU4xT31TKIBplRF0IkqRKlCgfLJol30=;
        b=Xby5Ak4MGCvbfJQDH9RgIBpJ7ud8v/bYNBMmTNvPlgRfw4ceXutUEndOOBZ6FvKmne
         /m4Mmf5w0gBLFFk1FBOs2ho4xYFfIaI1zMG8mqRPXG3uj6K7N/ZPwX28SYTy3ekopzbs
         hq0/55FgbSOALCjOmBUQw7u+1wMO8jXxfkehHfXHOsMB1NiAaPEkidC282DKS+9Q6sw0
         nXXwPcC7+YfDcYOplELpS7swqFr9W3r/o+Ct4Zte+dC4tcH6eRuY8CYnFevaCMBJ7I+z
         R4hPz97jW56z52zUlMAneBAmi49J72is2YmRZS/xSDbXP/FryfwHQg88N3TsX8Io9roQ
         sD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5phApT5KIAC+uU4xT31TKIBplRF0IkqRKlCgfLJol30=;
        b=07MdeAQJVWkruYBgPsq4VP29+jpe3Da6K2VMBkZL+HW8MnpXvB/Apfuksd/CwbcSvZ
         m50UJiEbFJpf7qfuvaIYD4Fow0ehbSkO3qNVSC5Muyc3xAfWaL4fhsHse3ZX30u2UryT
         34zAcQQCUo0kmRSlyaKmS6fNZw1Jx0qBn2TNLMAhy/mNZ5WUxLAt/Sm+dZrn6xk8MQTU
         GnRHwqgrGFww+fxCRPb/DSLGTMxXcWQIsQh5STe5HEQv8mMz+QPTs6cuKJK1Pa47/AU7
         zaAvAXq37FO6HJDbH8jmKC0VS0AMa1XiI59V6si6dBM2x1d07vuq+FdRc2KuMLyTX/ZQ
         8vKA==
X-Gm-Message-State: AO0yUKV4B3kGP3+Rp74Fi9UIzGRVSD27kI7/2q53Vvh4arzjqdTisBtv
	WLqbFsnpifHhbRnVQsr1LGTF901qiI1u3NwCUAk=
X-Google-Smtp-Source: AK7set9c2bqfEa/WvsjgUSoNZf3yG4q6yN5HhL1cKAlR3naz5zYCmz1a+lbbOE7KDjDQKA7s66o9VdJMNMaoYdA/jQE=
X-Received: by 2002:a63:3ec8:0:b0:4fb:8fb6:37e3 with SMTP id
 l191-20020a633ec8000000b004fb8fb637e3mr48435pga.6.1676620953779; Fri, 17 Feb
 2023 00:02:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <cfb0292c-e84d-0a7c-be74-ae5508779502@arm.com> <CANW9uyvXofhGGuhGzk_0Et-w8CHT2y35WSu5+hno6Qm8K4R4ug@mail.gmail.com>
In-Reply-To: <CANW9uyvXofhGGuhGzk_0Et-w8CHT2y35WSu5+hno6Qm8K4R4ug@mail.gmail.com>
From: Itaru Kitayama <itaru.kitayama@gmail.com>
Date: Fri, 17 Feb 2023 17:02:22 +0900
Message-ID: <CANW9uyuY2Ca9dxYQTtFLFupd-A088NTtmhdE=ST6o6Qn1_XM_A@mail.gmail.com>
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, 
	James Morse <james.morse@arm.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Quentin Perret <qperret@google.com>, Sean Christopherson <seanjc@google.com>, 
	Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"

On Sat, Feb 11, 2023 at 7:53 AM Itaru Kitayama <itaru.kitayama@gmail.com> wrote:
>
> On Sat, Feb 11, 2023 at 1:56 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
> >
> > On 27/01/2023 11:22, Suzuki K Poulose wrote:
> > > [...]
> >
> > > Running the stack
> > > ====================
> > >
> > > To run/test the stack, you would need the following components :
> > >
> > > 1) FVP Base AEM RevC model with FEAT_RME support [4]
> > > 2) TF-A firmware for EL3 [5]
> > > 3) TF-A RMM for R-EL2 [3]
> > > 4) Linux Kernel [6]
> > > 5) kvmtool [7]
> > > 6) kvm-unit-tests [8]
> > >
> > > Instructions for building the firmware components and running the model are
> > > available here [9]. Once, the host kernel is booted, a Realm can be launched by
> > > invoking the `lkvm` commad as follows:
> > >
> > >  $ lkvm run --realm                            \
> > >        --measurement-algo=["sha256", "sha512"] \
> > >        --disable-sve                           \
> > >        <normal-vm-options>
> > >
> > > Where:
> > >  * --measurement-algo (Optional) specifies the algorithm selected for creating the
> > >    initial measurements by the RMM for this Realm (defaults to sha256).
> > >  * GICv3 is mandatory for the Realms.
> > >  * SVE is not yet supported in the TF-RMM, and thus must be disabled using
> > >    --disable-sve
> > >
> > > You may also run the kvm-unit-tests inside the Realm world, using the similar
> > > options as above.
> >
> > Building all of these components and configuring the FVP correctly can be quite
> > tricky, so I thought I would plug a tool we have called Shrinkwrap, which can
> > simplify all of this.
> >
> > The tool accepts a yaml input configuration that describes how a set of
> > components should be built and packaged, and how the FVP should be configured
> > and booted. And by default, it uses a Docker container on its backend, which
> > contains all the required tools, including the FVP. You can optionally use
> > Podman or have it run on your native system if you prefer. It supports both
> > x86_64 and aarch64. And you can even run it in --dry-run mode to see the set of
> > shell commands that would have been executed.
> >
> > It comes with two CCA configs out-of-the-box; cca-3world.yaml builds TF-A, RMM,
> > Linux (for both host and guest), kvmtool and kvm-unit-tests. cca-4world.yaml
> > adds Hafnium and some demo SPs for the secure world (although since Hafnium
> > requires x86_64 to build, cca-4world.yaml doesn't currently work on an aarch64
> > build host).
> >
> > See the documentation [1] and repository [2] for more info.
> >
> > Brief instructions to get you up and running:
> >
> >   # Install shrinkwrap. (I assume you have Docker installed):
> >   sudo pip3 install pyyaml termcolor tuxmake
> >   git clone https://git.gitlab.arm.com/tooling/shrinkwrap.git
> >   export PATH=$PWD/shrinkwrap/shrinkwrap:$PATH
> >
> >   # If running Python < 3.9:
> >   sudo pip3 install graphlib-backport
> >
> >   # Build all the CCA components:
> >   shrinkwrap build cca-3world.yaml [--dry-run]
>
> This has been working on my Multipass instance on M1, thanks for the tool.
>
> Thanks,
> Itaru.

It took a while though I've just booted an Ubuntu 22.10 disk image
with the cca-3world.yaml config on M1.

Thanks,
Itaru.

>
> >
> >   # Run the stack in the FVP:
> >   shrinkwrap run cca-3world.yaml -r ROOTFS=<my_rootfs.ext4> [--dry-run]
> >
> > By default, building is done at ~/.shrinkwrap/build/cca-3world and the package
> > is created at ~/.shrinkwrap/package/cca-3world (this can be changed with
> > envvars).
> >
> > The 'run' command will boot TF-A, RMM and host Linux kernel in the FVP, and
> > mount the provided rootfs. You will likely want to have copied the userspace
> > pieces into the rootfs before running, so you can create realms:
> >
> > - ~/.shrinkwrap/package/cca-3world/Image (kernel with RMI and RSI support)
> > - ~/.shrinkwrap/package/cca-3world/lkvm (kvmtool able to launch realms)
> > - ~/.shrinkwrap/package/cca-3world/kvm-unit-tests.tgz (built kvm-unit-tests)
> >
> > Once the FVP is booted to a shell, you can do something like this to launch a
> > Linux guest in a realm:
> >
> >   lkvm run --realm --disable-sve -c 1 -m 256 -k Image
> >
> > [1] https://shrinkwrap.docs.arm.com
> > [2] https://gitlab.arm.com/tooling/shrinkwrap
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
