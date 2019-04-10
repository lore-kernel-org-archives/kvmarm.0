From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/2] kvm: arm: Unify stage2 mapping for THP backed memory
Date: Wed, 10 Apr 2019 16:23:50 +0100
Message-ID: <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, julien.thierry@arm.com, marc.zyngier@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, eric.auger@redhat.com, zhengxiang9@huawei.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com, andrew.murray@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


This series cleans up the handling of the stage2 huge mapping for THP.
Applies on top of [1]


[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-April/645324.html

Suzuki K Poulose (2):
  kvm: arm: Clean up the checking for huge mapping
  kvm: arm: Unify handling THP backed host memory

 virt/kvm/arm/mmu.c | 127 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

-- 
2.7.4
