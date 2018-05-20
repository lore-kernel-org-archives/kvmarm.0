From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PULL v8] KVM: arm64: Optimise FPSIMD context switching
Date: Sun, 20 May 2018 14:14:41 +0100
Message-ID: <20180520141441.3d999f16@why.wild-wind.fr.eu.org>
References: <20180516104942.GS7753@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180516104942.GS7753@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 16 May 2018 11:49:42 +0100
Dave Martin <Dave.Martin@arm.com> wrote:

Hi Dave,

> Hi Marc,
> 
> This is a trivial update to the previously posted v7 [1].  The only
> changes are a couple of minor cosmetic changes requested by reviewers,
> on-list and the addition of Acked-by/Reviewed-by tags received since the
> series was posted.
> 
> Let me know if you need anything else on this.

So I've taken this, merged in Linus' top of tree, started a guest on a
dual A53 board, and immediately hit the following:

root@sy-borg:~# [  287.226184] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  287.231672] Mem abort info:
[  287.234537]   ESR = 0x96000044
[  287.237674]   Exception class = DABT (current EL), IL = 32 bits
[  287.243765]   SET = 0, FnV = 0
[  287.246900]   EA = 0, S1PTW = 0
[  287.250126] Data abort info:
[  287.253083]   ISV = 0, ISS = 0x00000044
[  287.257025]   CM = 0, WnR = 1
[  287.260076] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000b8483f75
[  287.266882] [0000000000000000] pgd=0000000000000000
[  287.271903] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[  287.277636] Modules linked in:
[  287.280776] CPU: 1 PID: 3098 Comm: kworker/u4:3 Not tainted 4.17.0-rc5-00166-gd84e81cca249 #136
[  287.289730] Hardware name: Globalscale Marvell ESPRESSOBin Board (DT)
[  287.296364] pstate: 40000085 (nZcv daIf -PAN -UAO)
[  287.301301] pc : fpsimd_save_state+0x0/0x54
[  287.305595] lr : fpsimd_save+0x50/0x100
[  287.309531] sp : ffff00000dde3af0
[  287.312936] x29: ffff00000dde3af0 x28: ffff000008cd565c 
[  287.318401] x27: ffff800078ee9c80 x26: ffff80007b207628 
[  287.323867] x25: ffff0000093f9000 x24: 0000000000000001 
[  287.329333] x23: ffff0000093d4000 x22: ffff80007b207000 
[  287.334798] x21: ffff80007efd7d80 x20: ffff80007b207000 
[  287.340264] x19: 0000000000000000 x18: 0000000000040f0b 
[  287.345729] x17: 0000ffffb70752b8 x16: 0000ffffb708e008 
[  287.351195] x15: 0000000000000000 x14: 0000000000000400 
[  287.356661] x13: 0000000000000001 x12: 0000000000000001 
[  287.362127] x11: 0000000000000001 x10: 0000000000000000 
[  287.367592] x9 : 0000000000000253 x8 : ffff80007b207200 
[  287.373057] x7 : ffff80007b207100 x6 : ffff80007c378f18 
[  287.378523] x5 : 00000042c2094c00 x4 : 0000000000000000 
[  287.383990] x3 : 00000042e0033450 x2 : 0000000000000000 
[  287.389454] x1 : 0000800075bf6000 x0 : 0000000000000000 
[  287.394922] Process kworker/u4:3 (pid: 3098, stack limit = 0x00000000ca0dd8c6)
[  287.402358] Call trace:
[  287.404873]  fpsimd_save_state+0x0/0x54
[  287.408813]  fpsimd_thread_switch+0x28/0xa0
[  287.413114]  __switch_to+0x1c/0xd0
[  287.416609]  __schedule+0x1b8/0x730
[  287.420191]  preempt_schedule_common+0x24/0x48
[  287.424760]  preempt_schedule.part.23+0x1c/0x28
[  287.429419]  preempt_schedule+0x1c/0x28
[  287.433363]  _raw_spin_unlock+0x34/0x48
[  287.437308]  flush_old_exec+0x45c/0x6a0
[  287.441250]  load_elf_binary+0x324/0x1198
[  287.445372]  search_binary_handler+0xac/0x230
[  287.449851]  do_execveat_common.isra.14+0x508/0x6e0
[  287.454867]  do_execve+0x28/0x30
[  287.458185]  call_usermodehelper_exec_async+0xdc/0x140
[  287.463468]  ret_from_fork+0x10/0x18
[  287.467143] Code: a9425bf5 a8c37bfd d65f03c0 d65f03c0 (ad000400) 
[  287.473414] ---[ end trace c4346b99cc877f8e ]---

It happened just after having loaded the guest kernel, so I presume
we're missing some kind of initialization. I couldn't subsequently
reproduce it  on the same machine, and the same kernel is doing
absolutely fine on a Seattle box.

I can't immediately see how st would be NULL, unless we somehow are
missing some state tracking somewhere...

Any idea?

	M.
-- 
Without deviation from the norm, progress is not possible.
