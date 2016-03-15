From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 5/9] irqchip/gic-v3: Gather all ACPI specific data in a
 single structure
Date: Tue, 15 Mar 2016 12:26:29 +0000
Message-ID: <56E7FF75.7060701@arm.com>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-6-git-send-email-julien.grall@arm.com>
 <20160309053930.GH26583@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E37049AF5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2016 08:26:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xmgapVB5RY1L for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2016 08:26:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08DEE413E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2016 08:26:12 -0400 (EDT)
In-Reply-To: <20160309053930.GH26583@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 09/03/16 05:39, Christoffer Dall wrote:
> On Tue, Mar 08, 2016 at 11:29:29AM +0000, Julien Grall wrote:
>> Even though all the variables aren't marked with __initdata, they are
>> only used during initialization. So the structure is marked with
>> __initdata.
>
> Not sure I understand this commit message.
>
> As I see it, this commit includes two changes:
>
> 1. Mark the variables only used during init with __initdata
>
> 2. Move the variables into a structure
>
> If I get that right, can you argue for both changes?

What about:

"The ACPI code requires to use global variables in order to collect 
information from the tables.

To make clear those variables are ACPI specific, gather all of them in a 
single structure.

Furthermore, even if some of the variables are not marked with 
__initdata, they are all only used during the initialization. Therefore, 
the new variable, which hold the structure, can be marked __initdata."

Cheers,

-- 
Julien Grall
