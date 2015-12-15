From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: ARM64/KVM: Bad page state in process iperf
Date: Tue, 15 Dec 2015 10:29:15 +0100
Message-ID: <20151215092915.GF4120@cbox>
References: <DM2PR03MB557D3079ABFE7AF114A58A690EE0@DM2PR03MB557.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA66412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 04:27:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vAT2b9CCq7Xv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 04:27:00 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB747411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 04:26:59 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id p66so100448291wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 01:29:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <DM2PR03MB557D3079ABFE7AF114A58A690EE0@DM2PR03MB557.namprd03.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 15, 2015 at 03:46:03AM +0000, Bhushan Bharat wrote:
> 
> Hi All,
> 
> I am running "iperf" in KVM guest on ARM64 machine and observing below crash.

Which host/guest kernel version is this?

Which hardware?

-Christoffer

> 
> =============================
> $iperf -c 3.3.3.3 -P 4 -t 0 -i 5 -w 90k
> ------------------------------------------------------------
> Client connecting to 3.3.3.3, TCP port 5001
> TCP window size:  180 KByte (WARNING: requested 90.0 KByte)
> ------------------------------------------------------------
> [  3] local 3.3.3.1 port 51131 connected with 3.3.3.3 port 5001
> [  6] local 3.3.3.1 port 51134 connected with 3.3.3.3 port 5001
> [  5] local 3.3.3.1 port 51133 connected with 3.3.3.3 port 5001
> [  4] local 3.3.3.1 port 51132 connected with 3.3.3.3 port 5001
> [   53.088567] random: nonblocking pool is initialized
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0- 5.0 sec   638 MBytes  1.07 Gbits/sec
> [  4] 35.0-40.0 sec  1.66 GBytes  2.85 Gbits/sec
> [  5] 40.0-45.0 sec  1.11 GBytes  1.90 Gbits/sec
> [  4] 40.0-45.0 sec  1.16 GBytes  1.99 Gbits/sec
> [   98.895207] BUG: Bad page state in process iperf  pfn:0a584
> [   98.896164] page:ffff780000296100 count:-1 mapcount:0 mapping:          (null) index:0x0
> [   98.897436] flags: 0x0()
> [   98.897885] page dumped because: nonzero _count
> [   98.898640] Modules linked in:
> [   98.899178] CPU: 0 PID: 1639 Comm: iperf Not tainted 4.1.8-00461-ge5431ad #141
> [   98.900302] Hardware name: linux,dummy-virt (DT)
> [   98.901014] Call trace:
> [   98.901406] [<ffff800000096cac>] dump_backtrace+0x0/0x12c
> [   98.902522] [<ffff800000096de8>] show_stack+0x10/0x1c
> [   98.903441] [<ffff800000678dc8>] dump_stack+0x8c/0xdc
> [   98.904202] [<ffff800000145480>] bad_page+0xc4/0x114
> [   98.904945] [<ffff8000001487a4>] get_page_from_freelist+0x590/0x63c
> [   98.905871] [<ffff80000014893c>] __alloc_pages_nodemask+0xec/0x794
> [   98.906791] [<ffff80000059fc80>] skb_page_frag_refill+0x70/0xa8
> [   98.907678] [<ffff80000059fcd8>] sk_page_frag_refill+0x20/0xd0
> [   98.908550] [<ffff8000005edc04>] tcp_sendmsg+0x1f8/0x9a8
> [   98.909368] [<ffff80000061419c>] inet_sendmsg+0x5c/0xd0
> [   98.910178] [<ffff80000059bb44>] sock_sendmsg+0x14/0x58
> [   98.911027] [<ffff80000059bbec>] sock_write_iter+0x64/0xbc
> [   98.912119] [<ffff80000019b5b8>] __vfs_write+0xac/0x10c
> [   98.913126] [<ffff80000019bcb8>] vfs_write+0x90/0x1a0
> [   98.913963] [<ffff80000019c53c>] SyS_write+0x40/0xa0
> 
> -----------
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
