Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0426EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 08:51:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92F854B18A;
	Tue, 30 Nov 2021 03:51:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vj4mSSIX-T3O; Tue, 30 Nov 2021 03:51:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B62BB4B1BF;
	Tue, 30 Nov 2021 03:51:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A8BF4B15E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 17:54:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pY+qHYwAwURK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 17:54:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 721E84B152
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 17:54:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638226490;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EBs8K8t7lGxGRJRgDQFXR8lGz6ECPAkAgLHVeZTQziQ=;
 b=DNQZVcghs1rb8CMP9mqWvQVLJwnqUpFrQZiUTRmahg5ssF0e5ClYVOOSOTdzrWpR/+6H+I
 0sD0yc0YkwHC41ipPTx4m1Onm/1uO7S5Bqp1T1LsBVpSuQv7p59m9SwkLb09QUew3YvXOW
 KzSarIabFPWt4x2v/zXs0GqGEma9AA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-_y8EtH9fON-4WtdCdy8PgA-1; Mon, 29 Nov 2021 17:54:48 -0500
X-MC-Unique: _y8EtH9fON-4WtdCdy8PgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D98501B18BD1;
 Mon, 29 Nov 2021 22:54:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D923D78C2E;
 Mon, 29 Nov 2021 22:53:38 +0000 (UTC)
Message-ID: <458c0819a578ba854f00089bc312c8faa177a81a.camel@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Tue, 30 Nov 2021 00:53:37 +0200
In-Reply-To: <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
 <YaUiEquKYi5eqWC0@google.com>
 <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mailman-Approved-At: Tue, 30 Nov 2021 03:51:34 -0500
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Wei Huang <wei.huang2@amd.com>,
 kvm-ppc@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Anup Patel <anup.patel@wdc.com>,
 linux-mips@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, 2021-11-29 at 20:18 +0100, Paolo Bonzini wrote:
> On 11/29/21 19:55, Sean Christopherson wrote:
> > > Still it does seem to be a race that happens when IS_RUNNING=true but
> > > vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to
> > > trigger because it moves IS_RUNNING=false later.
> > 
> > Oh!  Any chance the bug only repros with preemption enabled?  That would explain
> > why I don't see problems, I'm pretty sure I've only run AVIC with a PREEMPT=n.
> 
> Me too.
> 
> > svm_vcpu_{un}blocking() are called with preemption enabled, and avic_set_running()
> > passes in vcpu->cpu.  If the vCPU is preempted and scheduled in on a different CPU,
> > avic_vcpu_load() will overwrite the vCPU's entry with the wrong CPU info.
> 
> That would make a lot of sense.  avic_vcpu_load() can handle 
> svm->avic_is_running = false, but avic_set_running still needs its body 
> wrapped by preempt_disable/preempt_enable.
> 
> Fedora's kernel is CONFIG_PREEMPT_VOLUNTARY, but I know Maxim uses his 
> own build so it would not surprise me if he used CONFIG_PREEMPT=y.
> 
> Paolo
> 

I will write ll the details tomorrow but I strongly suspect the CPU errata 
https://developer.amd.com/wp-content/resources/56323-PUB_0.78.pdf
#1235
 
Basically what I see that
 
1. vCPU2 disables is_running in avic physical id cache
2. vCPU2 checks that IRR is empty and it is
3. vCPU2 does schedule();
 
and it keeps on sleeping forever. If I kick it via signal 
(like just doing 'info registers' qemu hmp command
or just stop/cont on the same hmp interface, the
vCPU wakes up and notices that IRR suddenly is not empty,
and the VM comes back to life (and then hangs after a while again
with the same problem....).
 
As far as I see in the traces, the bit in IRR came from
another VCPU who didn't respect the ir_running bit and didn't get 
AVIC_INCOMPLETE_IPI VMexit.
I can't 100% prove it yet, but everything in the trace shows this.
 
About the rest of the environment, currently I reproduce this in
a VM which has no pci passed through devices at all, just AVIC.
(I wasn't able to reproduce it before just because I forgot to
enable AVIC in this configuration).
 
So I also agree that Sean's patch is not to blame here,
it just made the window between setting is_running and getting to sleep
shorter and made it less likely that other vCPUs will pick up the is_running change.
(I suspect that they pick it up on next vmrun, and otherwise the value is somehow
cached wrongfully in them).
 
A very performance killing workaround of kicking all vCPUs when one of them enters vcpu_block
does seem to work for me but it skews all the timing off so I can't prove it.
 
That is all, I will write more detailed info, including some traces I have.
 
I do use windows 10 with so called LatencyMon in it, which shows overall how
much latency hardware interrupts have, which used to be useful for me to
ensure that my VMs are suitable for RT like latency (even before I joined RedHat,
I tuned my VMs as much as I could to make my Rift CV1 VR headset work well which 
needs RT like latencies.
 
These days VR works fine in my VMs anyway, but I still kept this tool to keep an eye on it).
 
I really need to write a kvm unit test to stress test IPIs, especially this case,
I will do this very soon.
 
 
Wei Huang, any info on this would be very helpful. 
 
Maybe putting the avic physical table in UC memory would help? 
Maybe ringing doorbells of all other vcpus will help them notice the change?

Best regards,
	Maxim Levitsky

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
