From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test cases
Date: Mon, 28 Nov 2016 14:09:26 +0000
Message-ID: <CAFEAcA9WBbYeOeWfAt9dtosW=n+Zi1waF0EtckeoJHs7FsjGOQ@mail.gmail.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161128103744.s3wq53xzsxvu5uus@kamzik.brq.redhat.com>
 <878ts3uac6.fsf@linaro.org>
 <CAFEAcA9JUOHnJL59EuhQ_dEWjt+YjEcu8LGiJ3CSk_7R4J5Efg@mail.gmail.com>
 <20161128115824.hrofgivt2mlfk7fh@kamzik.brq.redhat.com>
 <CAFEAcA8-3qHnp1T4bAiUL3NT8fHWik7-8zruyQKGgfADn5xF9w@mail.gmail.com>
 <20161128140445.j336ksd7vqhi4ivz@kamzik.brq.redhat.com>
 <20161128140705.caqpoiuvxy3mg2zk@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5BCC40543
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 09:09:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hzh2+Nbz-ATC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 09:09:00 -0500 (EST)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com
 [209.85.213.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A3D54049A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 09:08:59 -0500 (EST)
Received: by mail-vk0-f51.google.com with SMTP id p9so73733581vkd.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 06:09:47 -0800 (PST)
In-Reply-To: <20161128140705.caqpoiuvxy3mg2zk@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: MTTCG Devel <mttcg@greensocs.com>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@siemens.com>, Mark Burton <mark.burton@greensocs.com>, QEMU Developers <qemu-devel@nongnu.org>, "Emilio G. Cota" <cota@braap.org>, Fedorov Sergey <serge.fdrv@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Pranith Kumar <bobby.prani@gmail.com>, Richard Henderson <rth@twiddle.net>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 28 November 2016 at 14:07, Andrew Jones <drjones@redhat.com> wrote:
> Er... actually mach-virt is 123, as we only allocate 123 redistributors.

Oh yes, I'd forgotten about that limit. We'd need to add
a KVM API for allocating redistributors in non-contiguous
bits of memory if we wanted to raise that.

thanks
-- PMM
