From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 2/2] arm/arm64: KVM: enable 32 bits kvm vcpu events
 support
Date: Fri, 12 Oct 2018 12:35:48 +0100
Message-ID: <51a366e2-1e40-8aac-4fe3-604b74542f29@arm.com>
References: <1539284855-4035-1-git-send-email-gengdongjiu@huawei.com>
 <1539284855-4035-3-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539284855-4035-3-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@arm.com, marc.zyngier@arm.com, suzuki.poulose@arm.com, peter.maydell@linaro.org, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 11/10/2018 20:07, Dongjiu Geng wrote:
> The commit 539aee0edb9f ("KVM: arm64: Share the parts of
> get/set events useful to 32bit") shares the get/set events
> helper for arm64 and arm32, 

Oops. I evidently didn't test this bit. Looks like I just depended on the symbol
to be defined, I didn't check the CAP was exposed.


> it is better also share the check
> for vcpu events capability to enable 32 bit kvm vcpu events
> support.

not just better, necessary for correctly-written user-space to know the feature
is supported. This last bit would be clearer as: "but forgot to share the cap
extension code."


Thanks for catching this!

Acked-by: James Morse <james.morse@arm.com>


Thanks,

James
