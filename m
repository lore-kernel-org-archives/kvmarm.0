From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 4/7] lib: arm: Implement PSCI SYSTEM_OFF
 in psci_system_off()
Date: Fri, 25 Jan 2019 15:25:19 +0100
Message-ID: <20190125142519.n7ytozr2scgsymju@kamzik.brq.redhat.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-5-alexandru.elisei@arm.com>
 <20190124130129.bkefj6kqofnohkt7@kamzik.brq.redhat.com>
 <c7a56d94-f972-d541-9cdd-c34bacd24557@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6C564A3A8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 09:25:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id apvR9xOMSGcI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 09:25:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC7214A39E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 09:25:24 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <c7a56d94-f972-d541-9cdd-c34bacd24557@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 25, 2019 at 02:08:45PM +0000, Alexandru Elisei wrote:
> 
> On 1/24/19 1:01 PM, Andrew Jones wrote:
> > On Thu, Jan 24, 2019 at 11:16:31AM +0000, Alexandru Elisei wrote:
> > > A new function psci_system_off() is added which implements the PSCI
> > > SYSTEM_OFF function. A call causes the hypervisor to terminate the virtual
> > > machine.
> > > 
> > > Consumers for the function will be added in a later patch.
> > > 
> > > Signed-off-by: Alexandru Elisei<alexandru.elisei@arm.com>
> > > ---
> > >   lib/arm/asm/psci.h | 1 +
> > >   lib/arm/psci.c     | 6 ++++++
> > >   2 files changed, 7 insertions(+)
> > > 
> > > diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> > > index ed51708fd265..93409996349a 100644
> > > --- a/lib/arm/asm/psci.h
> > > +++ b/lib/arm/asm/psci.h
> > > @@ -9,5 +9,6 @@ extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
> > >   extern void psci_sys_reset(void);
> > >   extern int cpu_psci_cpu_boot(unsigned int cpu);
> > >   extern void cpu_psci_cpu_die(void);
> > > +extern void psci_system_off(void);
> > >   #endif /* _ASMARM_PSCI_H_ */
> > > diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> > > index 119f74e57e91..d8dc428e8e8b 100644
> > > --- a/lib/arm/psci.c
> > > +++ b/lib/arm/psci.c
> > > @@ -48,6 +48,12 @@ void cpu_psci_cpu_die(void)
> > >   	printf("CPU%d unable to power off (error = %d)\n", smp_processor_id(), err);
> > >   }
> > > +void psci_system_off(void)
> > > +{
> > > +	int err = psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
> > > +	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
> > > +}
> > > +
> > >   void psci_sys_reset(void)
> > >   {
> > >   	psci_invoke(PSCI_0_2_FN_SYSTEM_RESET, 0, 0, 0);
> > > -- 
> > > 2.17.0
> > > 
> > We should either rename psci_sys_reset to psci_system_reset or name this
> > new function with the psci_sys_* pattern.
> > 
> > Thanks,
> > drew
> I am thinking we should rename psci_sys_reset() to match the PSCI
> specification function name, which is SYSTEM_OFF. If you're ok with it, I'll
> do the rename in the next patch set version.

Yup, I'm fine with the renaming.

Thanks,
drew
