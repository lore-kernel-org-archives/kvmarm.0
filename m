From: Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH V2] KVM: ARM: Remove pgtable page standard functions from
 stage-2 page tables
Date: Mon, 8 Apr 2019 11:18:42 -0600
Message-ID: <20190408171842.GA218114@google.com>
References: <3be0b7e0-2ef8-babb-88c9-d229e0fdd220@arm.com>
 <1552397145-10665-1-git-send-email-anshuman.khandual@arm.com>
 <20190401161638.GB22092@fuggles.cambridge.arm.com>
 <20190401183425.GA106130@google.com>
 <20190402090349.GA25936@fuggles.cambridge.arm.com>
 <20190408142212.GA4331@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190408142212.GA4331@fuggles.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: mark.rutland@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, Anshuman Khandual <anshuman.khandual@arm.com>, christoffer.dall@arm.com, linux-mm@kvack.org, james.morse@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 08, 2019 at 03:22:38PM +0100, Will Deacon wrote:
> On Tue, Apr 02, 2019 at 10:04:30AM +0100, Will Deacon wrote:
> > On Mon, Apr 01, 2019 at 12:34:25PM -0600, Yu Zhao wrote:
> > > On Mon, Apr 01, 2019 at 05:16:38PM +0100, Will Deacon wrote:
> > > > [+KVM/ARM folks, since I can't take this without an Ack in place from them]
> > > > 
> > > > My understanding is that this patch is intended to replace patch 3/4 in
> > > > this series:
> > > > 
> > > > http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/638083.html
> > > 
> > > Yes, and sorry for the confusion. I could send an updated series once
> > > this patch is merged. Thanks.
> > 
> > That's alright, I think I'm on top of it (but I'll ask you to check whatever
> > I end up merging). Just wanted to make it easy for the kvm folks to dive in
> > with no context!
> 
> Ok, I've pushed this out onto a temporary branch before I merge it into
> -next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=pgtable-ctors
> 
> Please can you confirm that it looks ok?

LGTM, thanks.
