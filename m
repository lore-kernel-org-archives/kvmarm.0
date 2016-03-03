From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 3/4] pre_init: add support for i386 also
Date: Thu, 3 Mar 2016 10:53:09 +0000
Message-ID: <56D81795.5000805@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
 <1456327988-31568-4-git-send-email-andre.przywara@arm.com>
 <20160302025646.GA7637@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAF47411BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 05:45:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m4snhYNPqtBo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2016 05:45:52 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A646410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 05:45:52 -0500 (EST)
In-Reply-To: <20160302025646.GA7637@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 02/03/16 02:57, Will Deacon wrote:
> On Wed, Feb 24, 2016 at 03:33:07PM +0000, Andre Przywara wrote:
>> Currently the pre_init support is provided only for x86_64. Since
>> having 32-bit x86 supported as well is not far off, just add an
>> implementation using i386 assembly instructions and the respective
>> syscall ABI.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  Makefile     |  1 +
>>  x86/init32.S | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 51 insertions(+)
>>  create mode 100644 x86/init32.S
> 
> Did you manage to test this?

Yes, I think I tested it back when I originally wrote this, but I just
redid the testing using a 32-bit Ubuntu-Core i386 chroot (and deleting
the .lkvm/default directory before testing to make sure you don't get an
older version of init).
It works fine and apart from the size of the binary I can't tell a
difference between booting with or without the patch.

Cheers,
Andre.
