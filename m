From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/4] arm64: KVM: Add support for Stage-2 control of
 memory types and cacheability
Date: Thu, 24 May 2018 16:52:25 +0100
Message-ID: <20180524155224.5prjpe6cnozm4tpl@armageddon.cambridge.arm.com>
References: <20180517103548.5622-1-marc.zyngier@arm.com>
 <20180517103548.5622-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180517103548.5622-2-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 17, 2018 at 11:35:45AM +0100, Marc Zyngier wrote:
> Up to ARMv8.3, the combinaison of Stage-1 and Stage-2 attributes
> results in the strongest attribute of the two stages.  This means
> that the hypervisor has to perform quite a lot of cache maintenance
> just in case the guest has some non-cacheable mappings around.
> 
> ARMv8.4 solves this problem by offering a different mode (FWB) where
> Stage-2 has total control over the memory attribute (this is limited
> to systems where both I/O and instruction caches are coherent with
> the dcache). This is achieved by having a different set of memory
> attributes in the page tables, and a new bit set in HCR_EL2.
> 
> On such a system, we can then safely sidestep any form of dcache
> management.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

For the core arm64 bits:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
