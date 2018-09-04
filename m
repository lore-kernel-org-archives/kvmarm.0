From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: gicv3: support two
 redistributor regions
Date: Tue, 4 Sep 2018 09:02:13 +0200
Message-ID: <20180904070213.rkl4fchslnfs52sy@kamzik.brq.redhat.com>
References: <20180903164507.24544-1-drjones@redhat.com>
 <CAFEAcA-eb=k1SVS2k4GenTEUsKuLYdx1DJ1SzTk-bHYaJcY-zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D36CA4A1E1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 03:02:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PIpbLA+3YstU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Sep 2018 03:02:16 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFD0149E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 03:02:16 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-eb=k1SVS2k4GenTEUsKuLYdx1DJ1SzTk-bHYaJcY-zg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 04, 2018 at 01:49:11AM +0100, Peter Maydell wrote:
> On 3 September 2018 at 17:45, Andrew Jones <drjones@redhat.com> wrote:
> > We need to support two redistributor regions in order to support
> > more than 123 vcpus. Also bump NR_CPUS to 512, since that's what
> > KVM currently supports.
> 
> Wouldn't it be neater to support the arbitrary number
> of redistributor regions that the h/w spec allows and
> the dt can describe, rather than just the specific case
> of 2 regions that QEMU happens to use ?
>

It would be nicer, and I suppose it would be pretty easy to do
as well. kvm-unit-tests/arm has always been a balance between being
over-engineered for its purposes and being too hacky. In this case,
I was probably too hacky. Although KVM only supports up to 512 VCPUS
right now and these two regions support up to 635, so it'll be a while
before a third region will be needed.

If I find time I'll send a v2, but in the meantime it'd be good to
get test results with this version to be sure I didn't miss anything
else.

Thanks,
drew
