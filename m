From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 2/4] mm: speed up mremap by 500x on large regions (v2)
Date: Tue, 16 Oct 2018 13:29:52 +0200
Message-ID: <35b9c85a-b366-9ca3-5647-c2568c811961@suse.cz>
References: <20181013013200.206928-1-joel@joelfernandes.org>
 <20181013013200.206928-3-joel@joelfernandes.org>
 <20181015094209.GA31999@infradead.org>
 <20181015223303.GA164293@joelaf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181015223303.GA164293@joelaf.mtv.corp.google.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Joel Fernandes <joel@joelfernandes.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-mips@linux-mips.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, mhocko@kernel.org, linux-mm@kvack.org, lokeshgidra@google.com, sparclinux@vger.kernel.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Jonas Bonn <jonas@southpole.se>, linux-s390@vger.kernel.org, dancol@google.com, Yoshinori Sato <ysato@users.sourceforge.jp>, Max Filippov <jcmvbkbc@gmail.com>, linux-hexagon@vger.kernel.org, Helge Deller <deller@gmx.de>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>, hughd@google.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, kasan-dev@googlegroups.com, elfring@users.sourceforge.net, Ingo Molnar <mingo@redhat.com>, Geert
List-Id: kvmarm@lists.cs.columbia.edu

On 10/16/18 12:33 AM, Joel Fernandes wrote:
> On Mon, Oct 15, 2018 at 02:42:09AM -0700, Christoph Hellwig wrote:
>> On Fri, Oct 12, 2018 at 06:31:58PM -0700, Joel Fernandes (Google) wrote:
>>> Android needs to mremap large regions of memory during memory management
>>> related operations.
>>
>> Just curious: why?
> 
> In Android we have a requirement of moving a large (up to a GB now, but may
> grow bigger in future) memory range from one location to another.

I think Christoph's "why?" was about the requirement, not why it hurts
applications. I admit I'm now also curious :)

> This move
> operation has to happen when the application threads are paused for this
> operation. Therefore, an inefficient move like it is now (for example 250ms
> on arm64) will cause response time issues for applications, which is not
> acceptable. Huge pages cannot be used in such memory ranges to avoid this
> inefficiency as (when the application threads are running) our fault handlers
> are designed to process 4KB pages at a time, to keep response times low. So
> using huge pages in this context can, again, cause response time issues.
> 
> Also, the mremap syscall waiting for quarter of a second for a large mremap
> is quite weird and we ought to improve it where possible.
