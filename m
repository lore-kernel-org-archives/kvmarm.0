From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 08/41] KVM: arm/arm64: Introduce vcpu_el1_is_32bit
Date: Fri, 9 Feb 2018 12:31:25 +0000
Message-ID: <eefa89b7-74d1-7ced-cf11-cdba96341755@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-9-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180112120747.27999-9-christoffer.dall@linaro.org>
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
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> We have numerous checks around that checks if the HCR_EL2 has the RW bit
> set to figure out if we're running an AArch64 or AArch32 VM.  In some
> cases, directly checking the RW bit (given its unintuitive name), is a
> bit confusing, and that's not going to improve as we move logic around
> for the following patches that optimize KVM on AArch64 hosts with VHE.
> 
> Therefore, introduce a helper, vcpu_el1_is_32bit, and replace existing
> direct checks of HCR_EL2.RW with the helper.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Julien Grall <julien.grall@arm.com>

Cheers,

-- 
Julien Grall
