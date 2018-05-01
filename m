From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 01/12] ACPI / APEI: Move the estatus queue code up, and
 under its own ifdef
Date: Tue, 1 May 2018 13:50:43 +0100
Message-ID: <4d3b63b0-66ad-8903-ea9a-6fa590a017d5@arm.com>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-2-james.morse@arm.com>
 <877eonr708.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <877eonr708.fsf@e105922-lin.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Punit,

On 01/05/18 11:43, Punit Agrawal wrote:
> James Morse <james.morse@arm.com> writes:
>> Notes for cover letter:
>> ghes.c has three things all called 'estatus'. One is a pool of memory
>> that has a static size, and is grown/shrunk when new NMI users are
>> allocated.
>> The second is the cache, this holds recent notifications so we can
>> suppress notifications we've already handled.
>> The last is the queue, which hold data from NMI notifications (in pool
>> memory) that can't be handled immediatly.
> 
> 
> I am guessing you intended to drop the notes before sending the patch
> out.

Ha, oops!

> Calling this out as it'd make sense to clean-this up if the series is
> ready for merging.

Yes, thanks for calling that out.

I've deleted them now (copy-paste cover-letter serves the same purpose), so any
v4 will drop this.


Thanks,

James
