From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 2/4] mm: speed up mremap by 500x on large regions (v2)
Date: Wed, 17 Oct 2018 09:38:16 +0200
Message-ID: <80a7d851-51ca-2d81-1273-393d4f701bc4@suse.cz>
References: <20181013013200.206928-1-joel@joelfernandes.org>
 <20181013013200.206928-3-joel@joelfernandes.org>
 <20181015094209.GA31999@infradead.org>
 <20181015223303.GA164293@joelaf.mtv.corp.google.com>
 <35b9c85a-b366-9ca3-5647-c2568c811961@suse.cz>
 <20181016194313.GA247930@joelaf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181016194313.GA247930@joelaf.mtv.corp.google.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-riscv/>
List-Post: <mailto:linux-riscv@lists.infradead.org>
List-Help: <mailto:linux-riscv-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=subscribe>
Sender: "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Errors-To: linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-mips@linux-mips.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, mhocko@kernel.org, linux-mm@kvack.org, lokeshgidra@google.com, sparclinux@vger.kernel.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Jonas Bonn <jonas@southpole.se>, linux-s390@vger.kernel.org, dancol@google.com, Yoshinori Sato <ysato@users.sourceforge.jp>, Max Filippov <jcmvbkbc@gmail.com>, linux-hexagon@vger.kernel.org, Helge Deller <deller@gmx.de>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>, hughd@google.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, kasan-dev@googlegroups.com, elfring@users.sourceforge.net, Christoph Hellwig <hch@infradead.org>, Ingo
List-Id: kvmarm@lists.cs.columbia.edu

On 10/16/18 9:43 PM, Joel Fernandes wrote:
> On Tue, Oct 16, 2018 at 01:29:52PM +0200, Vlastimil Babka wrote:
>> On 10/16/18 12:33 AM, Joel Fernandes wrote:
>>> On Mon, Oct 15, 2018 at 02:42:09AM -0700, Christoph Hellwig wrote:
>>>> On Fri, Oct 12, 2018 at 06:31:58PM -0700, Joel Fernandes (Google) wrote:
>>>>> Android needs to mremap large regions of memory during memory management
>>>>> related operations.
>>>>
>>>> Just curious: why?
>>>
>>> In Android we have a requirement of moving a large (up to a GB now, but may
>>> grow bigger in future) memory range from one location to another.
>>
>> I think Christoph's "why?" was about the requirement, not why it hurts
>> applications. I admit I'm now also curious :)
> 
> This issue was discovered when we wanted to be able to move the physical
> pages of a memory range to another location quickly so that, after the
> application threads are resumed, UFFDIO_REGISTER_MODE_MISSING userfaultfd
> faults can be received on the original memory range. The actual operations
> performed on the memory range are beyond the scope of this discussion. The
> user threads continue to refer to the old address which will now fault. The
> reason we want retain the old memory range and receives faults there is to
> avoid the need to fix the addresses all over the address space of the threads
> after we finish with performing operations on them in the fault handlers, so
> we mremap it and receive faults at the old addresses.
> 
> Does that answer your question?

Yes, interesting, thanks!

Vlastimil

> thanks,
> 
> - Joel
> 
