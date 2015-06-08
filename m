From: Peter Maydell <peter.maydell@linaro.org>
Subject: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Mon, 8 Jun 2015 11:52:50 +0100
Message-ID: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Igor Mammedov <imammedo@redhat.com>
Cc: Eric Auger <eric.auger@linaro.org>, Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 June 2015 at 11:32, Igor Mammedov <imammedo@redhat.com> wrote:
> On Thu, 4 Jun 2015 18:17:39 +0100
> Peter Maydell <peter.maydell@linaro.org> wrote:
>> On 4 June 2015 at 17:40, Shlomo Pongratz <shlomopongratz@gmail.com> wrote:
>>  In order for it to work correctly we must use MPIDR values in
>>  the device tree which match the MPIDR values the kernel has picked
>>  for the vcpus, so ask KVM what those values are.

> Could we set QEMU's generated mpidr in kernel instead of pulling it from kernel,
> like we do with APIC ID in x86 and fix kernel not to reset it its own value
> (i.e. untie mpidr from vcpuid)?
>
> Then later we could move setting mpidr from kvm_arch_init_vcpu() into
> board code which should be setting it, since it knows/defines what topology it has.

This is a question better asked on the kvmarm list (which I have cc'd),
because that is where the kernel folks hang out...

-- PMM
